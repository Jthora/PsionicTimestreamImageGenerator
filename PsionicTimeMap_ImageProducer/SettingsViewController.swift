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
    
    // Radio Buttons
    @IBOutlet weak var radioButtonUseDatabase: NSButton!
    @IBOutlet weak var radioButtonUseCoreAstrology: NSButton!
    
    // Core Astrology Settings
    @IBOutlet weak var sampleDensityLabel: NSTextField!
    @IBOutlet weak var sampleDensityTextField: NSTextField!
    @IBOutlet weak var sampleDensityPxLabel: NSTextField!
    
    @IBOutlet weak var latitudeLabel: NSTextField!
    @IBOutlet weak var latitudeTextField: NSTextField!
    @IBOutlet weak var latitudeDegLabel: NSTextField!
    
    @IBOutlet weak var longitudeLabel: NSTextField!
    @IBOutlet weak var longitudeTextField: NSTextField!
    @IBOutlet weak var longitudeDegLabel: NSTextField!
    
    @IBOutlet weak var selectLocationOnMapButton: NSButton!
    @IBOutlet weak var advancedSettingsButton: NSButton!
    
    
    
    // Current UI State
    var selectedDataSource: Settings.ParserDataSource {
        get {
            return Settings.parserDataSource
        }
        set {
            Settings.parserDataSource = newValue
            updateUI()
        }
    }
    
    // View Did Load
    override func viewDidLoad() {
        print("Select Location Screen Opened")
        updateUI()
    }
    
    override func viewDidAppear() {
        print("viewDidAppear")
    }
    
    override func mouseDown(with event: NSEvent) {
        updateUI()
    }
    
    func updateUI() {
        print("updateUI")
        
        // Sample Density
        sampleDensityTextField.stringValue = Settings.sampleDensityString ?? ""
        sampleDensityTextField.placeholderString = "\(Settings.defaultSampleDensity)"
        
        // Latitude
        latitudeTextField.stringValue = Settings.manualLatitudeString ?? ""
        latitudeTextField.placeholderString = Settings.mapLatitudeString ?? "0.0º"
        
        // Longitude
        longitudeTextField.stringValue = Settings.manualLongitudeString ?? ""
        longitudeTextField.placeholderString = Settings.mapLongitudeString ?? "0.0º"
        
        // Radio Button Greyout Effect
        switch Settings.parserDataSource {
            case .database:
            
            radioButtonUseDatabase.state = .on
            radioButtonUseCoreAstrology.state = .off
            
            sampleDensityLabel.textColor = NSColor.tertiaryLabelColor
            sampleDensityTextField.isEnabled = false
            sampleDensityPxLabel.textColor = NSColor.tertiaryLabelColor
            
            latitudeLabel.textColor = NSColor.tertiaryLabelColor
            latitudeTextField.isEnabled = false
            latitudeDegLabel.textColor = NSColor.tertiaryLabelColor
            
            longitudeLabel.textColor = NSColor.tertiaryLabelColor
            longitudeTextField.isEnabled = false
            longitudeDegLabel.textColor = NSColor.tertiaryLabelColor
            
            selectLocationOnMapButton.isEnabled = false
            advancedSettingsButton.isEnabled = false
            
            case .coreAstrology:
            
            Settings.parserDataSource = .coreAstrology
            
            radioButtonUseDatabase.state = .off
            radioButtonUseCoreAstrology.state = .on
            
            sampleDensityLabel.textColor = NSColor.white
            sampleDensityTextField.isEnabled = true
            sampleDensityPxLabel.textColor = NSColor.white
            
            latitudeLabel.textColor = NSColor.white
            latitudeTextField.isEnabled = true
            latitudeDegLabel.textColor = NSColor.white
            
            longitudeLabel.textColor = NSColor.white
            longitudeTextField.isEnabled = true
            longitudeDegLabel.textColor = NSColor.white
            
            selectLocationOnMapButton.isEnabled = true
            advancedSettingsButton.isEnabled = true
        }
    }
    
    // Use Database Selected
    @IBAction func radioButtonUseDatabaseClicked(_ sender: NSButton) {
        print("Use Database Selected")
        selectedDataSource = .database
    }
    
    // Use Core Astrology Selected
    @IBAction func radioButtonUseCoreAstrologyClicked(_ sender: NSButton) {
        print("Use Core Astrology Selected")
        selectedDataSource = .coreAstrology
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
