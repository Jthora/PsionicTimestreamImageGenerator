//
//  InfoScreenViewController.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 1/15/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Cocoa

class InfoScreenViewController: NSViewController {
    
    @IBOutlet weak var versionLabel: NSTextField!
    
    override func viewDidLoad() {
        print("Info Screen Opened")
        
        let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "??"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "??"
        
        versionLabel.stringValue = "Version: \(appVersion) [\(appBuildNumber)]"
    }
    
    @IBAction func thoraTechHyperlinkClicked(_ sender: NSButton) {
        if let url = URL(string: "https://jono.thora.show") {
                NSWorkspace.shared.open(url)
            }
    }
    
}
