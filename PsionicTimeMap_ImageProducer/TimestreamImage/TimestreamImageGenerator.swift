//
//  TimestreamImageGenerator.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 8/31/20.
//  Copyright © 2020 Jordan Trana. All rights reserved.
//

import AppKit
import Cocoa

extension Timestream {
    final class ImageGenerator {
        
        private init() {}
        
        static func saveMultipleToDisk(timestreams: TimestreamSet,
                                         colorRenderMode: ColorRenderMode,
                                         renderOption: ColorRenderMode.RenderOption,
                                         markYears: Bool = false,
                                         markMonths: Bool = false,
                                         markerYearsWidth: Int = 2,
                                         markerMonthsWidth: Int = 1,
                                         filenamePrefix: String,
                                         startDate: Date,
                                         endDate: Date) {
            
            let openPanel = NSOpenPanel()
            
            openPanel.canCreateDirectories = true
            openPanel.canChooseFiles = false
            openPanel.canChooseDirectories = true
            openPanel.allowsMultipleSelection = false
            
            openPanel.begin { [self] (result) in
                
                switch result {
                case .OK:
                    for planet in Timestream.Planet.allCases {
                        guard let timestream = timestreams[planet],
                            let imageStrip: ImageStrip = self.generateStrip(timestream: timestream,
                                                                            colorRenderMode: colorRenderMode,
                                                                            renderOption: renderOption,
                                                                            markYears: markYears,
                                                                            markMonths: markMonths) else {
                            print("ERROR: ImageStrip cannot be generated from Timestream")
                            return
                        }
                        
                        let cgImage = imageStrip.cgImage
                        let size = NSSize(width: imageStrip.width, height: 1)
                        let nsImage = NSImage(cgImage: cgImage, size: size)

                        let imageFilename = imageStrip.createFilename(filenamePrefix: filenamePrefix, showMarkings: true, showSampleCount: true, showDateRange: true)
                        
                        // Create URL
                        guard let destinationURL = openPanel.url,
                              let fullURL = URL(string: "\(destinationURL)\(imageFilename)") else {
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
        
        static var pixelsLeftForLargeMark:Int = 0
        static func generateStrip(timestream: Timestream,
                                  colorRenderMode: Timestream.ImageGenerator.ColorRenderMode,
                                  renderOption: Timestream.ImageGenerator.ColorRenderMode.RenderOption,
                                  markerYearsWidth: Int = 2,
                                  markerMonthsWidth: Int = 1,
                                  markYears:Bool,
                                  markMonths:Bool) -> Timestream.ImageStrip? {
            
            let width = timestream.samples.count
            let height = 1
            
            var rgbaArray:[RGBAColor] = timestream.samples.map { (sample) -> RGBAColor in
                
                // Trigger Year Marker
                if markYears && sample.yearDidChange {
                    pixelsLeftForLargeMark = markerYearsWidth//8
                }
                
                // Draw Year Marker
                if markYears && pixelsLeftForLargeMark > 0 {
                    pixelsLeftForLargeMark -= 1
                    return RGBAColor.black
                }
                
                // Trigger Month Marker
                if markMonths && sample.monthDidChange {
                    pixelsLeftForLargeMark = markerMonthsWidth//4
                }
                
                // Draw Month Marker
                if markMonths && pixelsLeftForLargeMark > 0 {
                    pixelsLeftForLargeMark -= 1
                    return RGBAColor.black
                }
                
                // Render RGBAColor for Timestream Sample and Color Render Mode and Render Option
                return colorRenderMode.renderColor(option: renderOption, sample: sample)
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
            
            return Timestream.ImageStrip(cgImage: cgImage,
                                         planet: timestream.planet,
                                         colorRenderMode: colorRenderMode,
                                         renderOption: renderOption,
                                         markMonths: markMonths,
                                         markYears: markYears,
                                         startDate: timestream.startDate,
                                         endDate: timestream.endDate)
        }
        
        // Color Render Mode
        enum ColorRenderMode: String, CaseIterable {
            
            // Color Render Modes
            case colorGradient
            case solidColors
            case blackWhite
            case greyscale
            case alphascale
            case clear
            
            // Color Render Options
            enum RenderOption: String, CaseIterable {
                case harmonics
                case retrogrades
                case gravimetrics
                case distance
                
                var title:String {
                    switch self {
                    case .harmonics: return "Harmonics"
                    case .retrogrades: return "Retrogrades"
                    case .gravimetrics: return "Gravimetrics"
                    case .distance: return "Distance"
                    }
                }
                
                var filenameText: String {
                    return self.rawValue
                }
                
                func has(title:String) -> Bool {
                    return self.title == title
                }
                
                static func from(title:String) -> RenderOption? {
                    for renderMode in RenderOption.allCases {
                        if renderMode.title == title { return renderMode }
                    }
                    return nil
                }
            }
            
            var title:String {
                switch self {
                case .colorGradient: return "Gradient RGYB Color (default)"
                case .solidColors: return "Solid RGYB Color"
                case .blackWhite: return "Black & White"
                case .greyscale: return "Grayscale"
                case .alphascale: return "Alphascale"
                case .clear: return "Clear"
                }
            }
            
            var shortTitle:String {
                switch self {
                case .colorGradient: return "Gradient Color"
                case .solidColors: return "Solid Color"
                case .blackWhite: return "Black & White"
                case .greyscale: return "Grayscale"
                case .alphascale: return "Alphascale"
                case .clear: return "Clear"
                }
            }
            
            var filenameText: String {
                return self.rawValue
            }
            
            func has(title:String) -> Bool {
                return self.title == title
            }
            
            static func from(title:String) -> ColorRenderMode? {
                for renderMode in ColorRenderMode.allCases {
                    if renderMode.title == title { return renderMode }
                }
                return nil
            }
            
            func renderColor(option: RenderOption, sample:Timestream.Sample) -> RGBAColor {
                let invert = option == .retrogrades && sample.planetState.retrogradeState == .retrograde
                switch self {
                case .clear:
                    return RGBAColor.clear
                case .colorGradient:
                    return RGBAColor(degrees: sample.planetState.degrees, invert: invert, solidColors: false)
                case .solidColors:
                    return RGBAColor(degrees: sample.planetState.degrees, invert: invert, solidColors: true)
                case .blackWhite:
                    return invert ? RGBAColor.black : RGBAColor.white
                case .greyscale:
                    switch option {
                    case .retrogrades: return RGBAColor.greyscale(brightness: 0)
                    case .harmonics: return RGBAColor.greyscale(brightness: 0)
                    case .distance: return RGBAColor.greyscale(brightness: 0)
                    case .gravimetrics: return RGBAColor.greyscale(brightness: 0)
                    }
                case .alphascale:
                    switch option {
                    case .retrogrades: return RGBAColor.alphascale(opacity: 0)
                    case .harmonics: return RGBAColor.alphascale(opacity: 0)
                    case .distance: return RGBAColor.alphascale(opacity: 0)
                    case .gravimetrics: return RGBAColor.alphascale(opacity: 0)
                    }
                }
            }
        }
    }

}
