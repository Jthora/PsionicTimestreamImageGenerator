//
//  SettingsViewController.swift
//  Psionic Timestream Image Generator
//
//  Created by Jordan Trana on 1/16/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Foundation

import Cocoa

class SettingsViewController: NSViewController {
    
    @IBOutlet weak var radioButtonUseDatabase: NSButton!
    @IBOutlet weak var radioButtonUseCoreAstrology: NSButton!
    
    var uiState:UIState = .useDatabase {
        didSet {
            switch uiState {
                case .useDatabase:
                radioButtonUseDatabase.state = .on
                radioButtonUseCoreAstrology.state = .off
                case .useCoreAstrology:
                radioButtonUseDatabase.state = .off
                radioButtonUseCoreAstrology.state = .on
            }
        }
    }
    
    enum UIState {
        case useDatabase
        case useCoreAstrology
    }
    
    override func viewDidLoad() {
        print("Select Location Screen Opened")
        
    }
    
    // Use Database Selected
    @IBAction func radioButtonUseDatabaseClicked(_ sender: NSButton) {
        print("Use Database Selected")
        uiState = .useDatabase
    }
    
    // Use Core Astrology Selected
    @IBAction func radioButtonUseCoreAstrologyClicked(_ sender: NSButton) {
        print("Use Core Astrology Selected")
        uiState = .useCoreAstrology
    }
    
    // Sample Density Changed
    @IBAction func textFieldSampleDensityChanged(_ sender: NSTextField) {
        let sampleDensity = sender.integerValue
        
        print("Set Sample Density: \(sampleDensity)")
    }
    
    // Latitude Changed
    @IBAction func textFieldLatitudeChanged(_ sender: NSTextField) {
        let degrees = sender.doubleValue
        
        print("Set Latitude: \(degrees)")
    }
    
    // Longitude Changed
    @IBAction func textFieldLongitudeChanged(_ sender: NSTextField) {
        let degrees = sender.doubleValue
        
        print("Set Longitude: \(degrees)")
    }
}
