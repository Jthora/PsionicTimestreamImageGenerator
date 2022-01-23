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
    static let logLengthLimit:Int = 5000
    
    static var logString: String = ""
    
    private init () {}
    
    // Report Parse Start
    static func parseStart() {
        log(text:"▶️ PARSE START")
    }
    
    // Report Parse Complete
    static func parseComplete(_ details: String) {
        log(text:"✅ PARSE COMPLETE\n\(details)")
    }
    
    // Report Render Start
    static func renderStart() {
        log(text:"⏩ RENDER START")
    }
    
    // Report Render Complete
    static func renderComplete(_ details: String) {
        log(text:"✅ RENDER COMPLETE\n\(details)")
    }
    
    // Report Saved Image
    static func saved(_ fileLocation: String) {
        log(text:"💾 SAVED\n📂: \(fileLocation)")
    }
    
    // Report Planet Set
    static func set(planetOption:Settings.PlanetOption) {
        set(text: planetOption.title)
    }
    
    // Report Data Metric Set
    static func set(dataMetric:Settings.DataMetricOption) {
        set(text: dataMetric.title)
    }
    
    // Report Color Mode Set
    static func set(colorRenderMode:Settings.ColorRenderModeOption) {
        set(text: colorRenderMode.title)
    }
    
    static func set(text:String) {
        log(text:"🔹 Set: \(text)")
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
