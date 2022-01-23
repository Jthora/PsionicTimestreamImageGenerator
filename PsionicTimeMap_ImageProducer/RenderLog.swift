//
//  RenderLog.swift
//  Psionic Timestream Image Generator
//
//  Created by Jordan Trana on 1/22/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Cocoa

final class RenderLog {
    
    static var renderConsoleTextField: NSTextField? = nil
    static let logLengthLimit:Int = 125
    
    static var logString: String = ""
    
    private init () {}
    
    // Report Render Complete
    static func renderStart(_ text: String) {
        log(text:"⭐️ RENDER START\n\(text)")
    }
    
    static func set(planetOption:Settings.PlanetOption) {
        set(text: planetOption.title)
    }
    
    static func set(renderOption:Timestream.ImageGenerator.ColorRenderMode.RenderOption) {
        set(text: renderOption.title)
    }
    
    static func set(colorRenderMode:Timestream.ImageGenerator.ColorRenderMode) {
        set(text: colorRenderMode.shortTitle)
    }
    
    static func set(text:String) {
        log(text:"🔹 Set: \(text)")
    }
    
    // Report Render Complete
    static func renderComplete(_ details: String) {
        log(text:"✅ RENDER COMPLETE\nDetails: \(details)")
    }
    
    // Report Error
    static func error(_ error: Error) {
        log(text:"🚫 ERROR: \(error.localizedDescription)")
    }
    
    // Report Error (as String)
    static func error(_ text: String) {
        log(text:"⛔️ ERROR: \(text)")
    }
    
    // Add Text to Log
    static func log(text: String) {
        print(text)
        logString = "\(text)\n\(logString)"
        renderConsoleTextField?.stringValue = "\(logString.prefix(logLengthLimit))"
    }
}
