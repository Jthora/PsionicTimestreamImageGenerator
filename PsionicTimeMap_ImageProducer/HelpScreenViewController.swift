//
//  HelpScreenViewController.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 1/15/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Cocoa

class HelpScreenViewController: NSViewController {
    
    @IBOutlet weak var readyHelpScreenButton: NSButton!
    @IBOutlet weak var parsingHelpScreenButton: NSButton!
    @IBOutlet weak var parseCompleteHelpScreenButton: NSButton!
    @IBOutlet weak var instructionImageButton: NSButton!
    
    override func viewDidLoad() {
        print("Help Screen Opened")
    }
    
    var currentHelpScreen:HelpScreen = .ready {
        didSet {
            instructionImageButton.image = NSImage(named: "PsionicTimestreamImageGenerator_HelpScreen_0\(currentHelpScreen.rawValue)")
            
            switch currentHelpScreen {
            case .ready:
                readyHelpScreenButton.isHighlighted = true
                parsingHelpScreenButton.isHighlighted = false
                parseCompleteHelpScreenButton.isHighlighted = false
            case .parsing:
                readyHelpScreenButton.isHighlighted = false
                parsingHelpScreenButton.isHighlighted = true
                parseCompleteHelpScreenButton.isHighlighted = false
            case .complete:
                readyHelpScreenButton.isHighlighted = false
                parsingHelpScreenButton.isHighlighted = false
                parseCompleteHelpScreenButton.isHighlighted = true
            }
            
        }
    }
    
    enum HelpScreen:Int {
        case ready = 1
        case parsing
        case complete
    }
    
    @IBAction func readyStateButtonClicked(_ sender: NSButton) {
        currentHelpScreen = .ready
        sender.isHighlighted = true
    }
    
    @IBAction func parsingStateButtonClicked(_ sender: NSButton) {
        currentHelpScreen = .parsing
        sender.isHighlighted = true
    }
    
    @IBAction func parseCompletedStateButtonClicked(_ sender: NSButton) {
        currentHelpScreen = .complete
        sender.isHighlighted = true
    }
    
    
    @IBAction func toggleHelpScreen(_ sender: Any) {
        var nextHelpScreenNumber = currentHelpScreen.rawValue + 1
        if nextHelpScreenNumber > 3 {
            nextHelpScreenNumber = 1
        }
        currentHelpScreen = HelpScreen(rawValue: nextHelpScreenNumber) ?? .ready
    }
    
}
