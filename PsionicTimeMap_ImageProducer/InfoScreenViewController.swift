//
//  InfoScreenViewController.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 1/15/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Cocoa

class InfoScreenViewController: ViewController {
    
    override func viewDidLoad() {
        print("Info Screen Opened")
    }
    
    @IBAction func thoraTechHyperlinkClicked(_ sender: NSButton) {
        if let url = URL(string: "https://jono.thora.show") {
                NSWorkspace.shared.open(url)
            }
    }
    
}
