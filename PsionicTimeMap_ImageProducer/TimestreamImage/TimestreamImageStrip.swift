//
//  TimestreamImageStrip.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 1/15/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Cocoa

extension Timestream {
    struct ImageStrip {
        var cgImage: CGImage
        let planet: Planet
        let colorRenderMode: ImageGenerator.ColorRenderMode
        let renderOption: ImageGenerator.ColorRenderMode.RenderOption
        let markMonths: Bool
        let markYears: Bool
        var width:Int { return cgImage.width }
        let height:Int = 1
        var startDate: Date
        var endDate: Date
        
        // Create Filename
        func createFilename(filenamePrefix:String? = nil, showMarkings:Bool = true, showSampleCount:Bool = true, showDateRange:Bool = true) -> String {
            // Return Image Filename
            return ImageStrip.createFilename(filenamePrefix: filenamePrefix,
                                             planet: planet,
                                             colorRenderMode: colorRenderMode,
                                             renderOption: renderOption,
                                             startDate: startDate,
                                             endDate: endDate,
                                             samples: width,
                                             markYears: markYears,
                                             markMonths: markMonths,
                                             showMarkings: showMarkings,
                                             showSampleCount: showSampleCount,
                                             showDateRange: showDateRange)
        }
        
        // Create Filename with Timestream
        static func createFilename(filenamePrefix:String? = nil,
                                   timestream:Timestream,
                                   colorRenderMode:Timestream.ImageGenerator.ColorRenderMode,
                                   renderOption:Timestream.ImageGenerator.ColorRenderMode.RenderOption,
                                   markYears: Bool,
                                   markMonths: Bool,
                                   showMarkings:Bool = true,
                                   showSampleCount:Bool = true,
                                   showDateRange:Bool = true) -> String {
            return createFilename(filenamePrefix: filenamePrefix,
                                  planet: timestream.planet,
                                  colorRenderMode: colorRenderMode,
                                  renderOption: renderOption,
                                  startDate: timestream.startDate,
                                  endDate: timestream.endDate,
                                  samples: timestream.samples.count,
                                  markYears: markYears,
                                  markMonths: markMonths,
                                  showMarkings: showMarkings,
                                  showSampleCount: showSampleCount,
                                  showDateRange: showDateRange)
        }
        
        // Create Filename
        static func createFilename(filenamePrefix:String? = nil,
                                   planet:Timestream.Planet,
                                   colorRenderMode:Timestream.ImageGenerator.ColorRenderMode,
                                   renderOption:Timestream.ImageGenerator.ColorRenderMode.RenderOption,
                                   startDate: Date,
                                   endDate: Date,
                                   samples:Int,
                                   markYears: Bool,
                                   markMonths: Bool,
                                   showMarkings:Bool = true,
                                   showSampleCount:Bool = true,
                                   showDateRange:Bool = true) -> String {
            
            // Marking
            let markingsPretextText = markYears || markMonths ? "-marking\(markMonths ? "Months" : "")\(markYears ? "Years" : "")" : ""
            let markingsText = showMarkings ? "\(markingsPretextText)" : ""
            
            // Filename Prefix
            let filenamePrefixText = filenamePrefix != nil ? "\(filenamePrefix!)-" : ""
            
            // Date Range
            let dateRangeString = showDateRange ? "-\(startDate.filenameString)-to-\(endDate.filenameString)" : ""
            
            // Sample Count
            let sampleCountText = showSampleCount ? "-\(samples)samples" : ""
            
            // Set New Image Filename
            let imageFilename = "\(filenamePrefixText)\(planet.rawValue)\(markingsText)-\(colorRenderMode.filenameText)-\(renderOption.filenameText)\(sampleCountText)\(dateRangeString).png"
            
            // Return Image Filename
            return imageFilename
        }
        
        // Save Image with Filename
        func save(filenamePrefix: String? = nil) {
            save(imageFilename: createFilename(filenamePrefix: filenamePrefix))
        }
        
        // Save Image with Filename
        func save(imageFilename: String) {
            let size = NSSize(width: width, height: height)
            let nsImage = NSImage(cgImage: cgImage, size: size)
            
            let savePanel = NSSavePanel()
            savePanel.nameFieldStringValue = imageFilename
            savePanel.begin { (result) in
                if result == .OK {
                    guard let destinationURL = savePanel.url else {
                        print("ERROR: Pressed OK on SavePanel but with no URL")
                        return
                    }

                    if nsImage.pngWrite(to: destinationURL, options: .atomic) {
                        print("File saved")
                    }
                }
            }
        }
    }

}
