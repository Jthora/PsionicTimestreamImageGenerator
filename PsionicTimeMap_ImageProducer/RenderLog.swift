//
//  RenderLog.swift
//  Psionic Timestream Image Generator
//
//  Created by Jordan Trana on 1/22/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Cocoa

final class RenderLog {
    
    static weak var renderConsoleTextView: NSTextView? = nil
    static weak var renderConsoleScrollView: NSScrollView? = nil
    static let logLengthLimit:Int = 5000
    
    static var logString: NSAttributedString = NSAttributedString()
    
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
    static func log(text rawString: String) {
        DispatchQueue.main.async {
            let string = "\(rawString)\n"
            
            // Font
            guard let font = NSFont(name: "HelveticaNeue", size: NSFont.smallSystemFontSize) else {
                preconditionFailure("String cannot form Range: \(string)")
            }
            
            // Text Range
            guard let range = string.range(of: string)?.nsRange(in: string) else {
                preconditionFailure("String cannot form Range: \(string)")
            }
            
            // Font and Color
            let attrStr = NSMutableAttributedString(string: string)
            let color = NSColor.systemBlue
            let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : color,
                                                              NSAttributedString.Key.font: font]
            attrStr.setAttributes(attributes, range: range)
            
            // Append
            renderConsoleTextView?.textStorage?.append(attrStr)
            
            // Scroll to Bottom
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1/60)) {
                let y = renderConsoleTextView?.frame.size.height ?? 0
                renderConsoleScrollView?.documentView?.scroll(NSPoint(x: 0, y: y))
            }
        }
    }
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}
