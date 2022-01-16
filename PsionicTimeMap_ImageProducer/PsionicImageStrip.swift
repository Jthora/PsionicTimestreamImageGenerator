//
//  PsionicImageStrip.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 1/15/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Cocoa

struct PsionicImageStrip {
    var cgImage: CGImage
    let planet: EphemerisDataParser.Planet
    let retrograde: Bool
    let retrogradeInverted: Bool
    let solidColors: Bool
    var width = 1
    let height = 1
    var startDate: Date
    var endDate: Date
    
    func saveToDisk() {
        
        let size = NSSize(width: width, height: 1)
        let nsImage = NSImage(cgImage: cgImage, size: size)
        
        let savePanel = NSSavePanel()
        let retrogradeText = retrograde ? "-retrogrades" : ""
        let invertedText = retrograde && retrogradeInverted ? "-inverted" : ""
        let solidColorText = solidColors ? "-solidColors" : ""
        let startDateString = startDate.filenameString
        let endDateString = endDate.filenameString
        
        let imageName = "imageStrip-\(startDateString)to\(endDateString)-\(width)_samples-\(self.planet.rawValue)\(retrogradeText)\(invertedText)\(solidColorText).png"
        savePanel.nameFieldStringValue = imageName
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
