//
//  MainViewController.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 8/31/20.
//  Copyright © 2020 Jordan Trana. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    // Marking Settings
    @IBOutlet weak var checkboxMarkYears: NSButton!
    @IBOutlet weak var checkboxMarkMonths: NSButton!
    @IBOutlet weak var markerYearsTextField: NSTextField!
    @IBOutlet weak var markerMonthsTextField: NSTextField!
    @IBOutlet weak var markerYearsStepper: NSStepper!
    @IBOutlet weak var markerMonthsStepper: NSStepper!
    
    // Parse Date Range
    @IBOutlet weak var startDatePicker: NSDatePicker!
    @IBOutlet weak var endDatePicker: NSDatePicker!
    @IBOutlet weak var parseDataButton: NSButton!
    @IBOutlet weak var parseProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var resetDataParserButton: NSButton!
    @IBOutlet weak var parsingLabel: NSTextField!
    
    // Render Settings
    @IBOutlet weak var popupList: NSPopUpButton!
    @IBOutlet weak var generateButton: NSButton!
    @IBOutlet weak var popupRenderList: NSPopUpButton!
    @IBOutlet weak var filenamePrefix: NSTextField!
    
    // Support Buttons
    @IBOutlet weak var helpButton: NSButton!
    @IBOutlet weak var infoButton: NSButton!
    @IBOutlet weak var settingsButton: NSButton!
    
    // UI States
    enum UIState {
        case notParsed
        case parsing
        case parsed
    }
    
    // Current UI State
    var uiState: UIState = .notParsed {
        didSet {
            DispatchQueue.main.async {
                switch self.uiState {
                case .notParsed:
                    // Empty Progress Indicator
                    self.parseProgressIndicator.doubleValue = 0
                    
                    // Parse and Reset
                    self.parseDataButton.isEnabled = true
                    self.resetDataParserButton.isEnabled = false
                    
                    // Parsing Status
                    self.parsingLabel.isHidden = true
                    self.parsingLabel.stringValue = "Ready"
                    
                    // Options and Generate Button
                    self.popupList.isEnabled = false
                    self.popupRenderList.isEnabled = false
                    self.generateButton.isEnabled = false
                    
                    // Date Pickers
                    self.startDatePicker.isEnabled = true
                    self.endDatePicker.isEnabled = true
                    
                    // Markers
                    self.checkboxMarkMonths.isEnabled = false
                    self.markerMonthsStepper.isEnabled = false
                    self.markerMonthsTextField.isEnabled = false
                    self.checkboxMarkYears.isEnabled = false
                    self.markerYearsStepper.isEnabled = false
                    self.markerYearsTextField.isEnabled = false
                    
                    // Filename Prefix
                    self.filenamePrefix.isEnabled = false
                    
                case .parsing:
                    // Parse and Reset
                    self.parsingLabel.isHidden = false
                    self.parseDataButton.isEnabled = false
                    self.resetDataParserButton.isEnabled = false
                    
                    // Parsing Status
                    self.parsingLabel.stringValue = "Parsing..."
                    
                    // Options and Generate Button
                    self.popupList.isEnabled = false
                    self.popupRenderList.isEnabled = false
                    self.generateButton.isEnabled = false
                    
                    // Date Pickers
                    self.startDatePicker.isEnabled = false
                    self.endDatePicker.isEnabled = false
                    
                    // Markers
                    self.checkboxMarkMonths.isEnabled = false
                    self.markerMonthsStepper.isEnabled = false
                    self.markerMonthsTextField.isEnabled = false
                    self.checkboxMarkYears.isEnabled = false
                    self.markerYearsStepper.isEnabled = false
                    self.markerYearsTextField.isEnabled = false
                    
                    // Filename Prefix
                    self.filenamePrefix.isEnabled = false
                    
                case .parsed:
                    // Fill Progress Indicator
                    self.parseProgressIndicator.doubleValue = 1
                    
                    // Parse and Reset
                    self.parseDataButton.isEnabled = false
                    self.resetDataParserButton.isEnabled = true
                    
                    // Parsing Status
                    self.parsingLabel.stringValue = "Parsed"
                    
                    // Options and Generate Button
                    self.popupList.isEnabled = true
                    self.popupRenderList.isEnabled = true
                    self.generateButton.isEnabled = true
                    
                    // Date Pickers
                    self.startDatePicker.isEnabled = false
                    self.endDatePicker.isEnabled = false
                    
                    // Markers
                    self.checkboxMarkMonths.isEnabled = true
                    self.markerMonthsStepper.isEnabled = true
                    self.markerMonthsTextField.isEnabled = true
                    self.checkboxMarkYears.isEnabled = true
                    self.markerYearsStepper.isEnabled = true
                    self.markerYearsTextField.isEnabled = true
                    
                    // Filename Prefix
                    self.filenamePrefix.isEnabled = true
                }
            }
        }
    }
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        uiState = .notParsed
        setupUI()
    }
    
    // Setup UI
    func setupUI(state:UIState = .notParsed) {
        
        // ToolTips
        settingsButton.toolTip = "Settings"
        infoButton.toolTip = "Info"
        helpButton.toolTip = "Instructions"
        
        
        // Clear Popup Lists
        popupList.removeAllItems()
        popupRenderList.removeAllItems()
        
        // Add an "All" Option for Auto-generating image strips for each available planet option
        popupList.addItem(withTitle: Constants.Option.All.rawValue)
        
        // Add Planets as Options
        for planet in EphemerisDataParser.Planet.allCases {
            popupList.addItem(withTitle: planet.rawValue)
        }
        
        // Add an Option for each Planet
        for colorRenderMode in ColorRenderMode.allCases {
            popupRenderList.addItem(withTitle: colorRenderMode.title)
        }
        
        // Preselection First Option "All"
        popupList.selectItem(at: 0)
        
        // Set Parser
        EphemerisDataParser.main.startDate = startDatePicker.dateValue
        EphemerisDataParser.main.endDate = endDatePicker.dateValue
        
        // Numbers Only
        markerYearsTextField.formatter = OnlyIntegerValueFormatter()
        markerMonthsTextField.formatter = OnlyIntegerValueFormatter()
    }
    
    // Parse Ephemeris Data (galactic centered - sidereal astrology - planetary positions) [Galactic Centered Only!]
    @IBAction func parseDataButtonPressed(_ sender: Any) {
        
        // Set UI
        uiState = .parsing
        
        // Parse from Start Date to End Date
        EphemerisDataParser.main.parse(from: startDatePicker.dateValue,
                                       to: endDatePicker.dateValue) {  [weak self] percentComplete in
            DispatchQueue.main.async {
                // Set Percent Complete (0 to 1)
                self?.parseProgressIndicator.doubleValue = percentComplete
            }
        } onComplete: { [weak self] in
            DispatchQueue.main.async {
                // Set to Full
                self?.uiState = .parsed
            }
        }
    }
    
    // Generate & Save PNG Image Strip
    @IBAction func generateButtonPressed(_ sender: NSButton) {
        
        // Date Range
        let startDate = startDatePicker.dateValue
        let endDate = endDatePicker.dateValue
        
        // Setup Parser
        EphemerisDataParser.main.startDate = startDate
        EphemerisDataParser.main.endDate = endDate
        
        // Selected Option
        guard let selectedPlanetOption = popupList.titleOfSelectedItem else {
            print("ERROR:: generateButtonPressed:\n titleOfSelectedItem doesn't exist, found Nil")
            return
        }
        
        // Render All Options or Render Only Selected
        if selectedPlanetOption == Constants.Option.All.rawValue { // Yes: Render All
            PsionicImageGenerator.main.saveAllPlanetsToDisk(filenamePrefix: filenamePrefix.stringValue, startDate: startDate, endDate: endDate)
        } else { // No: Only Render the Specific Option Selected
            
            // Get Selected Planet
            guard let planet = EphemerisDataParser.Planet.init(rawValue: selectedPlanetOption) else {
                print("ERROR:: generateButtonPressed:\n Cannot generate image strip from popup list")
                return
            }
            
            // Create Samples
            guard let platnetStateTimeline = EphemerisDataParser.main.platnetStateTimeline(for: planet) else {
                print("ERROR:: generateButtonPressed:\n Cannot get degreesArray from Planet")
                return
            }
            
            // Set Render Mode to: Selected Render Option from PopUp List
            guard let colorRenderModeTitle = popupRenderList.titleOfSelectedItem,
                  let colorRenderMode = ColorRenderMode.from(title: colorRenderModeTitle) else {
                print("ERROR:: generateButtonPressed:\n RenderMode UI selectedItem not recognized")
                return
            }
            PsionicImageGenerator.main.colorRenderMode = colorRenderMode
            
            // Generate Psionic Image Strip
            guard let imageStrip = PsionicImageGenerator.main.generateStrip(planet: planet, planetStateTimeline: platnetStateTimeline, startDate: startDate, endDate: endDate) else {
                print("ERROR:: generateButtonPressed:\n Cannot generateStrip")
                return
            }
            imageStrip.saveToDisk()
        }
    }
    
    // Start Date Picker Changed
    @IBAction func startDatePickerChanged(_ sender: NSDatePicker) {
        
        EphemerisDataParser.main.startDate = sender.dateValue
        popupList.isEnabled = false
        generateButton.isEnabled = false
        parseDataButton.isEnabled = true
    }
    
    // End Date Picker Changed
    @IBAction func endDatePickerChanged(_ sender: NSDatePicker) {
        
        EphemerisDataParser.main.endDate = sender.dateValue
        popupList.isEnabled = false
        generateButton.isEnabled = false
        parseDataButton.isEnabled = true
    }
    
    // Represented Object
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // Mark Years Checked
    @IBAction func markYearsChecked(_ sender: NSButton) {
        switch sender.state {
        case .on:
            PsionicImageGenerator.main.markYears = true
        default:
            PsionicImageGenerator.main.markYears = false
        }
    }
    
    // Mark Months Checked
    @IBAction func markMonthsChecked(_ sender: NSButton) {
        switch sender.state {
        case .on:
            PsionicImageGenerator.main.markMonths = true
        default:
            PsionicImageGenerator.main.markMonths = false
        }
    }
    
    // Planet Option Selected
    @IBAction func onSelectPlanetOption(_ sender: NSPopUpButton) {
        print("Planet Option Selected: \(sender.titleOfSelectedItem ?? "??")")
    }
    
    
    // Render Option Selected
    @IBAction func onSelectRenderOption(_ sender: NSPopUpButton) {
        print("Render Option Selected: \(sender.titleOfSelectedItem ?? "??")")
        
        guard let colorRenderModeTitle = sender.titleOfSelectedItem else {
            print("ERROR:: onSelectRenderOption:\n Nil Title Selected?")
            return
        }
        
        guard let colorRenderMode = ColorRenderMode.from(title: colorRenderModeTitle) else {
            print("ERROR:: onSelectRenderOption:\n Title Selected is NOT a Render Mode")
            return
        }
        
        PsionicImageGenerator.main.colorRenderMode = colorRenderMode
    }
    
    // Help Button Clicked
    @IBAction func helpButtonClicked(_ sender: NSButton) {
        print("Help Button Clicked")
    }
    
    // Mark Years Stepper Changed
    @IBAction func markYearsStepperChanged(_ sender: NSStepper) {
        markerYearsTextField.stringValue = "\(sender.integerValue)"
        PsionicImageGenerator.main.markerYearsWidth = markerYearsTextField.integerValue
    }
    
    // Mark Months Stepper Changed
    @IBAction func markMonthsStepperChanged(_ sender: NSStepper) {
        markerMonthsTextField.stringValue = "\(sender.integerValue)"
        PsionicImageGenerator.main.markerMonthsWidth = markerMonthsTextField.integerValue
    }
    
    // Mark Years TextField Changed
    @IBAction func markYearsTextFieldChanged(_ sender: NSTextField) {
        markerYearsStepper.integerValue = sender.integerValue
        PsionicImageGenerator.main.markerYearsWidth = sender.integerValue
    }
    
    // Mark Months TextField Changed
    @IBAction func marksMonthsTextFieldChanged(_ sender: NSTextField) {
        markerMonthsStepper.integerValue = sender.integerValue
        PsionicImageGenerator.main.markerMonthsWidth = sender.integerValue
    }
    
    // Reset Button Clicked
    @IBAction func resetDataParserButtonClicked(_ sender: NSButton) {
        EphemerisDataParser.main.resetParser()
        resetUI()
    }
    
    // Reset UI
    func resetUI() {
        uiState = .notParsed
        setupUI()
    }
}

