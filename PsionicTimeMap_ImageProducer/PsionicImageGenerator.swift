//
//  PsionicImageGenerator.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 8/31/20.
//  Copyright © 2020 Jordan Trana. All rights reserved.
//

import AppKit
import Cocoa


class PsionicImageGenerator {
    
    static let main:PsionicImageGenerator = PsionicImageGenerator()
    
    var imageStrip:PsionicImageStrip? = nil
    var markYears: Bool = true
    var markMonths: Bool = true
    var markerYearsWidth: Int = 2
    var markerMonthsWidth: Int = 1
    
    var colorRenderMode:ColorRenderMode = .Gradient_Color {
        didSet {
            print("didSet colorRenderMode: \(colorRenderMode)")
        }
    }
    
    func saveAllPlanetsToDisk(filenamePrefix: String, startDate: Date, endDate: Date) {
        
        // Generate Image Filename
        var retrogradeText = ""
        var invertedText = ""
        var solidColorText = ""
        var startDateString = startDate.filenameString
        var endDateString = endDate.filenameString
        
        let openPanel = NSOpenPanel()
        
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        
        openPanel.begin { [self] (result) in
            
            switch result {
            case .OK:
                for planet in EphemerisDataParser.Planet.allCases {
                    
                    guard let planetStateTimeline = EphemerisDataParser.main.platnetStateTimeline(for: planet) else {
                        print("ERROR: Cannot get degreesArray from Planet")
                        continue
                    }
                    
                    guard let cgImageStrip = self.generateStrip(planet: planet, planetStateTimeline: planetStateTimeline, startDate: startDate, endDate: endDate) else { return }
                    
                    let cgImage = cgImageStrip.cgImage
                    let size = NSSize(width: cgImageStrip.width, height: 1)
                    let nsImage = NSImage(cgImage: cgImage, size: size)

                    // Set New Image Filename
                    retrogradeText = cgImageStrip.retrograde ? "-retrogrades" : ""
                    invertedText = cgImageStrip.retrograde && cgImageStrip.retrogradeInverted ? "-inverted" : ""
                    solidColorText = cgImageStrip.solidColors ? "-solidColors" : ""
                    startDateString = startDate.filenameString
                    endDateString = endDate.filenameString

                    // Image Filename
                    let imageName = "\(filenamePrefix)-\(startDateString)to\(endDateString)-\(cgImageStrip.width)_samples-\(planet.rawValue)\(retrogradeText)\(invertedText)\(solidColorText).png"
                    
                    // Create URL
                    guard let destinationURL = openPanel.url,
                          let fullURL = URL(string: "\(destinationURL)\(imageName)") else {
                        print("ERROR: Pressed OK on SavePanel but with no URL")
                        return
                    }
                    
                    // Write Image To Disk
                    if nsImage.pngWrite(to: fullURL, options: .atomic) {
                        print("File saved: \(fullURL)")
                    }
                }
            default: break
            }
        }
    }
    
    

    var pixelsLeftForLargeMark:Int = 0
    func generateStrip(planet: EphemerisDataParser.Planet, planetStateTimeline:[EphemerisDataParser.PlanetState], startDate:Date, endDate:Date) -> PsionicImageStrip? {
        
        let width = planetStateTimeline.count
        let height = 1
        
        var rgbaArray:[RGBAColor] = planetStateTimeline.map { (planetState) -> RGBAColor in
            
            // Trigger Year Marker
            if markYears && planetState.yearDidChange {
                pixelsLeftForLargeMark = markerYearsWidth//8
            }
            
            // Draw Year Marker
            if markYears && pixelsLeftForLargeMark > 0 {
                pixelsLeftForLargeMark -= 1
                return RGBAColor.black
            }
            
            // Trigger Month Marker
            if markMonths && planetState.monthDidChange {
                pixelsLeftForLargeMark = markerMonthsWidth//4
            }
            
            // Draw Month Marker
            if markMonths && pixelsLeftForLargeMark > 0 {
                pixelsLeftForLargeMark -= 1
                return RGBAColor.black
            }
            
            // Render RGBAColor for Planet State
            return colorRenderMode.color(for: planetState)
        }

        let bitmapCount: Int = rgbaArray.count
        let elmentLength: Int = 4 // Bytes
        let render: CGColorRenderingIntent = .defaultIntent//CGColorRenderingIntent.RenderingIntentDefault
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let providerRef: CGDataProvider = CGDataProvider(data: NSData(bytes: &rgbaArray, length: bitmapCount * elmentLength)) else {
            print("ERROR: CGDataProvider could not be generated")
            return nil
        }
        
        guard let cgImage: CGImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: width * elmentLength, space: rgbColorSpace, bitmapInfo: bitmapInfo, provider: providerRef, decode: nil, shouldInterpolate: true, intent: render) else {
            print("ERROR: CGImage could not be generated")
            return nil
        }
        
        return PsionicImageStrip(cgImage: cgImage,
                                 planet: planet,
                                 retrograde: colorRenderMode.retrograde,
                                 retrogradeInverted: colorRenderMode.retrogradeInverted,
                                 solidColors: colorRenderMode.solidColors,
                                 width: width,
                                 startDate: startDate,
                                 endDate: endDate)
    }
}
