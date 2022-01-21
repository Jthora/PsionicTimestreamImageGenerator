//
//  PsionicDataParser.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 8/31/20.
//  Copyright © 2020 Jordan Trana. All rights reserved.
//

import Foundation

typealias EphemerisDataParserOnStepCallback = ((Double)->Void)
typealias EphemerisDataParserOnCompleteCallback = (()->Void)

class EphemerisDataParser {
    
    static let main:EphemerisDataParser = EphemerisDataParser()
    
    let useDateRange:Bool = true
    
    let defaultFileName:String = "SiderealVedicEphemeris_GalacticCenter_1978-2062"
    let defaultFileType:String = ".txt"
    
    var fileContent:String? = nil
    var dataContent:[Planet:[PlanetState]] = [Planet:[PlanetState]]()
    
    var startDate:Date? = nil
    var endDate:Date? = nil
    
    // Parse
    func parse(from startDate:Date? = nil, // Start Date
               to endDate:Date? = nil, // End Date
               filename:String? = nil, // Ephemeris Filename
               fileType:String? = nil, // Ephemeris Filetype
               onStep:EphemerisDataParserOnStepCallback? = nil, // Callback for each Entry Parsed
               onComplete:EphemerisDataParserOnCompleteCallback? = nil) { // Callback indicating Parser is Done
        
        DispatchQueue.global().async {
            // Set Date Range
            self.startDate = startDate
            self.endDate = endDate
            
            // Load Specific File
            self.loadFile(filename, customFileType: fileType)
            
            // Parse Content of Loaded File for Set Date Range
            self.parseContent(onStep: onStep, onComplete: onComplete)
        }
    }
    
    func resetParser() {
        fileContent = nil
        dataContent = [Planet:[PlanetState]]()
        startDate = nil
        endDate = nil
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
    
    func parseContent(onStep:((Double)->Void)? = nil, onComplete:(()->Void)? = nil) {
        dataContent = [Planet:[PlanetState]]()
        
        guard let fileContent = fileContent else {
            print("ERROR: fileContent not loaded yet")
            return
        }
        
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
                if let startDate = startDate,
                   let year = year {
                    let startYear = Calendar.current.component(.hour, from: startDate)
                    if startYear > year {
                        continue
                    }
                } else {
                    print("WARNING: Could not determine startDate[\(startDate)] or parseYear[\(year)]")
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
                if let startDate = startDate {
                    let diff = date.timeIntervalSince(startDate)
                    if diff < 0 {
                        continue
                    } else {
                    }
                }
                if let endDate = endDate {
                    let diff = date.timeIntervalSince(endDate)
                    if diff > 0 {
                        print("Entries Parsed: \(dataContent[.sun]?.count ?? -1)")
                        onComplete?()
                        return
                    }
                }
            }
            
            // Callback onStep (with Percentage Completed)
            let percentageComplete = Double(rowIndex) / Double(rows.count)
            onStep?(percentageComplete)
            
            // Astrology Entries per Planet
            for (columnIndex,column) in columns.enumerated() {
                
                guard let planet = Planet.from(index: columnIndex) else {
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
                
                if dataContent[planet] == nil {
                    dataContent[planet] = [PlanetState]()
                }
                
                let retrogradeState:RetrogradeState
                let speed:Float
                if let lastDegrees = dataContent[planet]?.last?.degrees,
                    let lastRetrogradeState = dataContent[planet]?.last?.retrogradeState {
                    if lastDegrees < degrees {
                        retrogradeState = .direct
                    } else if lastDegrees > degrees {
                        retrogradeState = .retrograde
                    } else {
                        retrogradeState = lastRetrogradeState
                    }
                    speed = degrees - lastDegrees
                } else {
                    retrogradeState = .direct
                    speed = 0
                }
                
                
                let planetState = PlanetState(date:date, degrees: degrees, retrogradeState: retrogradeState, speed: speed, monthDidChange: monthDidChange, yearDidChange: yearDidChange)
                
                dataContent[planet]?.append(planetState)
                lastYear = year
                lastMonth = month
            }
        }
        
        print("Entries Parsed: \(dataContent[.sun]?.count ?? -1)")
        onComplete?()
    }
    
    func platnetStateTimeline(for planet:Planet) -> [PlanetState]? {
        return dataContent[planet]
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
    
    struct PlanetState {
        let date:Date?
        let degrees:Float
        let retrogradeState:RetrogradeState
        let speed:Float
        let monthDidChange:Bool
        let yearDidChange:Bool
    }
    
    enum RetrogradeState {
        case direct
        case retrograde
    }
    
    
    enum Planet:String, CaseIterable {
        case sun
        case moon
        case mercury
        case venus
        case mars
        case jupiter
        case saturn
        case uranus
        case neptune
        case pluto
        case northnode
        case perigee
        case asteroidbelt
        
        var column:Int {
            switch self {
            case .sun: return 0
            case .moon: return 1
            case .mercury: return 2
            case .venus: return 3
            case .mars: return 4
            case .jupiter: return 5
            case .saturn: return 6
            case .uranus: return 7
            case .neptune: return 8
            case .pluto: return 9
            case .northnode: return 10
            case .perigee: return 11
            case .asteroidbelt: return 12
            }
        }
        
        static func from(index:Int) -> Planet? {
            switch index {
                case 0: return .sun
                case 1: return .moon
                case 2: return .mercury
                case 3: return .venus
                case 4: return .mars
                case 5: return .jupiter
                case 6: return .saturn
                case 7: return .uranus
                case 8: return .neptune
                case 9: return .pluto
                case 10: return .northnode
                case 11: return .perigee
                case 12: return .asteroidbelt
            default: return nil
            }
        }
    }
}
