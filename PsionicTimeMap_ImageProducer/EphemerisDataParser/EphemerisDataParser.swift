//
//  EphemerisDataParser.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 8/31/20.
//  Copyright © 2020 Jordan Trana. All rights reserved.
//

import Foundation


struct Ephemeris {
    
    static let parser:DataParser = DataParser()
    static let minDate: Date = Date.init(year: 1978, month: 1, day: 1, timeZone: nil, hour: 0, minute: 0)!
    static let maxDate: Date = Date.init(year: 2062, month: 12, day: 31, timeZone: nil, hour: 0, minute: 0)!
    
    class DataParser {
        typealias OnStepCallback = ((Double)->Void)
        typealias OnCompleteCallback = ((Timestream.TimestreamSet)->Void)
        
        let useDateRange:Bool = true
        
        let defaultFileName:String = "SiderealVedicEphemeris_GalacticCenter_1978-2062"
        let defaultFileType:String = ".txt"
        
        var fileContent:String? = nil
        var timestreams:Timestream.TimestreamSet = Timestream.TimestreamSet()
        
        var startDate:Date = Ephemeris.minDate
        var endDate:Date = Ephemeris.maxDate
        
        // Parse
        func parse(from startDate:Date? = nil, // Start Date
                   to endDate:Date? = nil, // End Date
                   filename:String? = nil, // Ephemeris Filename
                   fileType:String? = nil, // Ephemeris Filetype
                   onStep:OnStepCallback? = nil, // Callback for each Entry Parsed
                   onComplete:OnCompleteCallback? = nil) { // Callback indicating Parser is Done
            
            DispatchQueue.global().async {
                // Set Date Range
                self.startDate = startDate ?? self.startDate
                self.endDate = endDate ?? self.endDate
                
                // Load Specific File
                self.loadFile(filename, customFileType: fileType)
                
                // Parse Content of Loaded File for Set Date Range
                self.parseContent(onStep: onStep, onComplete: onComplete)
            }
        }
        
        func resetParser() {
            fileContent = nil
            timestreams = [Timestream.Planet:Timestream]()
            startDate = Ephemeris.minDate
            endDate = Ephemeris.maxDate
        }
        
        func loadFile(_ customFileName:String? = nil, customFileType:String? = nil) {
            let fileName:String = customFileName ?? defaultFileName
            let fileType:String = customFileType ?? defaultFileType
            
            guard let path = Bundle.main.path(forResource: fileName, ofType: fileType) else {
                print("🚫 ERROR: fileName does not exist: \"\(fileName)\(fileType)\"")
                return
            }
            
            do {
                fileContent = try String(contentsOfFile: path)
                //print(fileContent)
            } catch {
                print("error: \(error)")
            }
        }
        
        func parseContent(onStep:OnStepCallback? = nil, onComplete:OnCompleteCallback? = nil) {
            
            // Confirm File Content Exists
            guard let fileContent = fileContent else {
                print("ERROR: fileContent not loaded yet")
                return
            }
            
            // Reset Timestreams
            timestreams = Timestream.TimestreamSet()
            
            // Setup Sample Array
            var allSamples = [Timestream.Planet:[Timestream.Sample]]()
            for planet in Timestream.Planet.allCases {
                allSamples[planet] = [Timestream.Sample]()
            }
            
            // Rows
            let rows:[String] = fileContent.components(separatedBy: "\n")
            
            // Date
            var year:Int? = nil
            var month:Month? = nil
            var day:Int? = nil
            var hour:Int? = nil
            var minute:Int? = nil
            
            // Marking Month and Year
            var lastYear:Int? = nil
            var lastMonth:Month? = nil
            
            // Iterating Through Each Row(Day) ~(but some Rows have Years or Months instead)
            for (rowIndex,row) in rows.enumerated() {
                
                // Check if Rows are Empty
                guard !row.isEmpty else {
                    print("ERROR: row[\(rowIndex)] is empty")
                    continue
                }
                
                // Year
                if row.count == 4 && row.isNumber && !row.contains(","),
                   let convertedYear = Int(row) {
                    year = convertedYear
                    continue
                }
                
                // Year Check
                if useDateRange {
                    if let year = year {
                        let startYear = Calendar.current.component(.hour, from: startDate)
                        if startYear > year {
                         continue
                        }
                    }
                }
                
                // Marking Years
                let yearDidChange:Bool = year != lastYear
                
                //Month
                if row.isWord && !row.contains(","),
                   let convertedMonth = Month(rawValue: row.lowercased()) {
                    month = convertedMonth
                    continue
                }
                
                // Marking Months
                let monthDidChange:Bool = month != lastMonth
                
                // Individual Day
                var columns = row.components(separatedBy: ",")
                
                if let first = columns.first { // Day Number
                    if let thisDay = Int(first) {
                        day = thisDay
                    } else {
                        print("WARNING: Column for Day is not a number: [\(first)]")
                    }
                }
                columns.removeFirst()
                if let _ = columns.first { // Day Name
                    // Do nothing
                }
                columns.removeFirst()
                if let third = columns.first { // Time
                    if third.contains(":") {
                        let timeSplit = third.components(separatedBy: ":")
                        hour = Int(timeSplit.first ?? "")
                        minute = Int(timeSplit.last ?? "")
                    }
                }
                columns.removeFirst()
                
                // Formulate Date
                var date:Date? = nil
                if let year = year,
                   let month = month,
                   let day = day,
                   let hour = hour,
                   let minute = minute {
                    date = Date(year: year, month: month.number, day: day, timeZone: TimeZone(secondsFromGMT: 0)!, hour: hour, minute: minute)
                } else {
                    print("WARNING: Date Missing. [year:\(year), month:\(month), day:\(day), hour:\(hour), minute:\(minute)]")
                }
                
                // Limit Date Range
                if useDateRange,
                   let date = date {
                    let startDiff = date.timeIntervalSince(startDate)
                    if startDiff < 0 {
                        continue
                    } else {
                    }
                    let endDiff = date.timeIntervalSince(endDate)
                    if endDiff > 0 {
                        print("Entries Parsed: \(allSamples[.sun]?.count ?? -1)")
                        let timestreams = Timestream.generateTimestreamSet(allSamples: allSamples,
                                                         startDate: startDate ?? minDate,
                                                         endDate: endDate)
                        onComplete?(timestreams)
                        return
                    }
                }
                
                // Callback onStep (with Percentage Completed)
                let percentageComplete = Double(rowIndex) / Double(rows.count)
                onStep?(percentageComplete)
                
                // Astrology Entries per Planet
                for (columnIndex,column) in columns.enumerated() {
                    
                    guard let planet = Timestream.Planet.from(index: columnIndex) else {
                        print("ERROR: parser can't translate Planet from Index: \(columnIndex)")
                        continue
                    }
                    
                    let signAndDegreesAsString = column
                    let signAndDegrees:[String] = signAndDegreesAsString.components(separatedBy: " ")
                    var degreesAsString:String = signAndDegrees[1]
                    
                    if degreesAsString.contains("°") {
                        let degreesAsStringComponents = degreesAsString.components(separatedBy: "°")
                        degreesAsString = degreesAsStringComponents.first!
                    }
                    
                    guard let degrees = Float(degreesAsString) else {
                        print("ERROR: parser at rowIndex[\(rowIndex)] and columnIndex[\(columnIndex)-\(planet.rawValue)] can't convert String to Float: \(degreesAsString)")
                        continue
                    }
                    
                    var retrogradeState: Timestream.Planet.State.RetrogradeState = .direct
                    let degreeDelta:Float
                    if let lastDegrees = timestreams[planet]?.samples.last?.planetState.degrees,
                       let lastRetrogradeState = timestreams[planet]?.samples.last?.planetState.retrogradeState {
                        if lastDegrees < degrees {
                            retrogradeState = .direct
                        } else if lastDegrees > degrees {
                            retrogradeState = .retrograde
                        } else {
                            retrogradeState = lastRetrogradeState
                        }
                        degreeDelta = degrees - lastDegrees
                    } else {
                        retrogradeState = .direct
                        degreeDelta = 0
                    }
                    
                    let distance:Float = 0
                    
                    // Positive values for RGB are White
                    // Negative values for RGB are black
                    // Signed Integer with +/- values
                    // Alpha channel used to represent level
                    // RGB channels used to represent +/- Number
                    
                    let gravity:Float = 0
                    
                    let timestreamPlanetState = Timestream.Planet.State(degrees: degrees,
                                                                        degreeDelta: degreeDelta,
                                                                        distance: distance,
                                                                        retrogradeState: retrogradeState,
                                                                        gravity: gravity)
                    
                    let timestreamSample = Timestream.Sample(date: date,
                                                             monthDidChange: monthDidChange,
                                                             yearDidChange: yearDidChange,
                                                             planetState: timestreamPlanetState)
                    
                    allSamples[planet]?.append(timestreamSample)
                    lastYear = year
                    lastMonth = month
                }
            }
            
            // Create Timestream Set
            let timestreamSet = Timestream.generateTimestreamSet(allSamples: allSamples,
                                             startDate: startDate,
                                             endDate: endDate)
            print("Entries Parsed: \(timestreamSet[.sun]?.samples.count ?? -1)")
            
            // Call OnComplete with TimestreamSet
            onComplete?(timestreamSet)
        }
        
        enum Month:String, CaseIterable {
            case january
            case feburary
            case march
            case april
            case may
            case june
            case july
            case august
            case september
            case october
            case november
            case december
            
            var number:Int {
                switch self {
                case .january: return 1
                case .feburary: return 2
                case .march: return 3
                case .april: return 4
                case .may: return 5
                case .june: return 6
                case .july: return 7
                case .august: return 8
                case .september: return 9
                case .october: return 10
                case .november: return 11
                case .december: return 12
                }
            }
        }
    }
}
