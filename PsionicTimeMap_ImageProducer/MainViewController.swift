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
    @IBOutlet weak var planetOptionPopupList: NSPopUpButton!
    @IBOutlet weak var colorRenderModePopupList: NSPopUpButton!
    @IBOutlet weak var renderOptionPopupList: NSPopUpButton!
    @IBOutlet weak var filenamePrefix: NSTextField!
    
    // Generate Image Strip
    @IBOutlet weak var generateButton: NSButton!
    
    // Support Buttons
    @IBOutlet weak var helpButton: NSButton!
    @IBOutlet weak var infoButton: NSButton!
    @IBOutlet weak var settingsButton: NSButton!
    
    // Render Console
    @IBOutlet weak var renderConsoleTextField: NSTextField!
    
    // Filename Example
    @IBOutlet weak var filenameExampleLabel: NSTextField!
    
    // UI States
    enum UIState {
        case notParsed
        case parsing
        case parsed
    }
    
    // Current UI State
    var uiState: UIState = .notParsed {
        didSet {
            updateUIState()
        }
    }
    
    // Update UI State
    func updateUIState() {
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
                
                // Render Options
                self.planetOptionPopupList.isEnabled = false
                self.colorRenderModePopupList.isEnabled = false
                self.renderOptionPopupList.isEnabled = false
                
                // Generate Button
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
                
                // Render Options
                self.planetOptionPopupList.isEnabled = false
                self.colorRenderModePopupList.isEnabled = false
                self.renderOptionPopupList.isEnabled = false
                
                // Generate Button
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
                
                // Render Options
                self.planetOptionPopupList.isEnabled = true
                self.colorRenderModePopupList.isEnabled = true
                self.renderOptionPopupList.isEnabled = true
                
                // Generate Button
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
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        RenderLog.renderConsoleTextField = renderConsoleTextField
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
        planetOptionPopupList.removeAllItems()
        colorRenderModePopupList.removeAllItems()
        renderOptionPopupList.removeAllItems()
        
        // Add an "All" Option for Auto-generating image strips for each available planet option
        planetOptionPopupList.addItem(withTitle: Settings.PlanetOption.all.title)
        
        // Add Planets as Options
        for planet in Timestream.Planet.allCases {
            planetOptionPopupList.addItem(withTitle: Settings.PlanetOption.specific(planet: planet).title)
        }
        
        // Add an Option for each Planet
        for colorRenderMode in Timestream.ImageGenerator.ColorRenderMode.allCases {
            colorRenderModePopupList.addItem(withTitle: colorRenderMode.title)
        }
        
        // Add an Option for each Planet
        for renderOption in Timestream.ImageGenerator.ColorRenderMode.RenderOption.allCases {
            renderOptionPopupList.addItem(withTitle: renderOption.title)
        }
        
        // Preselection First Option "All"
        planetOptionPopupList.selectItem(at: 0)
        colorRenderModePopupList.selectItem(at: 0)
        renderOptionPopupList.selectItem(at: 0)
        
        // Numbers Only
        markerYearsTextField.formatter = OnlyIntegerValueFormatter()
        markerMonthsTextField.formatter = OnlyIntegerValueFormatter()
        
        // Update UI State
        updateUI(state: state)
    }
    
    // Update UI
    func updateUI(state:UIState = .notParsed) {
        updateFilenameExample()
        updateUIState()
    }
    
    func updateFilenameExample() {
        let filenameExample:String = Timestream.ImageStrip.createFilename(filenamePrefix: Settings.filenamePrefix,
                                                                          planet: .sun,
                                                                          colorRenderMode: Settings.colorRenderMode,
                                                                          renderOption: Settings.renderOption,
                                                                          startDate: Settings.startDate,
                                                                          endDate: Settings.endDate,
                                                                          samples: Settings.days,
                                                                          markYears: Settings.markYears,
                                                                          markMonths: Settings.markMonths,
                                                                          showMarkings: true,
                                                                          showSampleCount: true,
                                                                          showDateRange: true)
        filenameExampleLabel.stringValue = "Filename Example: \(filenameExample)"
    }
    
    // Parse Ephemeris Data (galactic centered - sidereal astrology - planetary positions) [Galactic Centered Only!]
    @IBAction func parseDataButtonPressed(_ sender: Any) {
        
        // Set UI
        uiState = .parsing
        
        // Parse from Start Date to End Date
        Ephemeris.parser.parse(from: startDatePicker.dateValue,
                                       to: endDatePicker.dateValue) {  [weak self] percentComplete in
            DispatchQueue.main.async {
                // Set Percent Complete (0 to 1)
                self?.parseProgressIndicator.doubleValue = percentComplete
            }
        } onComplete: { [weak self] timestreams in
            Settings.timestreams = timestreams
            DispatchQueue.main.async {
                // Set to Full
                self?.uiState = .parsed
            }
        }
    }
    
    // Generate & Save PNG Image Strip
    @IBAction func generateButtonPressed(_ sender: NSButton) {
        // Render All Options or Render Only Selected
        switch Settings.planetOption {
        case .all:
            // Generate Image Strip for Every Planet
            guard let timestreams = Settings.timestreams else {
                RenderLog.error("Timestreams missing")
                return
            }
            Timestream.ImageGenerator.saveMultipleToDisk(timestreams: timestreams,
                                                         colorRenderMode: Settings.colorRenderMode,
                                                         renderOption: Settings.renderOption,
                                                         markYears: Settings.markYears,
                                                         markMonths: Settings.markMonths,
                                                         markerYearsWidth: Settings.markerYearsWidth,
                                                         markerMonthsWidth: Settings.markerMonthsWidth,
                                                         filenamePrefix: Settings.filenamePrefix,
                                                         startDate: Settings.startDate,
                                                         endDate: Settings.endDate)
        case .specific(let planet):
            // Generate Image Strip for Single Planet
            guard let timestream = Settings.timestreams?[planet],
                  let imageStrip = Timestream.ImageGenerator.generateStrip(timestream: timestream,
                                                                           colorRenderMode: Settings.colorRenderMode,
                                                                           renderOption: Settings.renderOption,
                                                                           markerYearsWidth: Settings.markerYearsWidth,
                                                                           markerMonthsWidth: Settings.markerMonthsWidth,
                                                                           markYears: Settings.markYears,
                                                                           markMonths: Settings.markMonths) else {
                RenderLog.error("generateButtonPressed:\n Cannot generateStrip")
                return
            }
            imageStrip.save()
        }
    }
    
    // Start Date Picker Changed
    @IBAction func startDatePickerChanged(_ sender: NSDatePicker) {
        Settings.startDate = sender.dateValue
        updateUI()
    }
    
    // End Date Picker Changed
    @IBAction func endDatePickerChanged(_ sender: NSDatePicker) {
        Settings.endDate = sender.dateValue
        updateUI()
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
            Settings.markYears = true
        default:
            Settings.markYears = false
        }
        updateUI()
    }
    
    // Mark Months Checked
    @IBAction func markMonthsChecked(_ sender: NSButton) {
        switch sender.state {
        case .on:
            Settings.markMonths = true
        default:
            Settings.markMonths = false
        }
        updateUI()
    }
    
    // Planet Option Selected
    @IBAction func onSelectPlanetOption(_ sender: NSPopUpButton) {
        print("Planet Option Selected: \(sender.titleOfSelectedItem ?? "??")")
        // Select Option
        guard let selectedPlanetOption = planetOptionPopupList.titleOfSelectedItem,
              let planetOption = Settings.PlanetOption.from(title: selectedPlanetOption) else {
               RenderLog.error("Select Planet doesn't exist... how?")
            return
        }
        Settings.planetOption = planetOption
        updateUI()
    }
    
    // Render Option Selected
    @IBAction func onSelectRenderOption(_ sender: NSPopUpButton) {
        print("Render Option Selected: \(sender.titleOfSelectedItem ?? "??")")
        
        guard let renderOptionTitle = sender.titleOfSelectedItem else {
            print("ERROR:: onSelectRenderOption:\n Nil Title Selected?")
            return
        }
        
        guard let renderOption = Timestream.ImageGenerator.ColorRenderMode.RenderOption.from(title: renderOptionTitle) else {
            print("ERROR:: onSelectRenderOption:\n Title Selected is NOT a Render Mode")
            return
        }
        
        Settings.renderOption = renderOption
        updateUI()
    }
    
    // Render Option Selected
    @IBAction func onSelectColorRenderMode(_ sender: NSPopUpButton) {
        print("Render Option Selected: \(sender.titleOfSelectedItem ?? "??")")
        
        guard let colorRenderModeTitle = sender.titleOfSelectedItem else {
            print("ERROR:: onSelectRenderOption:\n Nil Title Selected?")
            return
        }
        
        guard let colorRenderMode = Timestream.ImageGenerator.ColorRenderMode.from(title: colorRenderModeTitle) else {
            print("ERROR:: onSelectRenderOption:\n Title Selected is NOT a Render Mode")
            return
        }
        
        Settings.colorRenderMode = colorRenderMode
        updateUI()
    }
    
    // Help Button Clicked
    @IBAction func helpButtonClicked(_ sender: NSButton) {
        print("Help Button Clicked")
    }
    
    // Mark Years Stepper Changed
    @IBAction func markYearsStepperChanged(_ sender: NSStepper) {
        markerYearsTextField.stringValue = "\(sender.integerValue)"
        Settings.markerYearsWidth = markerYearsTextField.integerValue
        updateUI()
    }
    
    // Mark Months Stepper Changed
    @IBAction func markMonthsStepperChanged(_ sender: NSStepper) {
        markerMonthsTextField.stringValue = "\(sender.integerValue)"
        Settings.markerMonthsWidth = markerMonthsTextField.integerValue
        updateUI()
    }
    
    // Mark Years TextField Changed
    @IBAction func markYearsTextFieldChanged(_ sender: NSTextField) {
        markerYearsStepper.integerValue = sender.integerValue
        Settings.markerYearsWidth = sender.integerValue
        updateUI()
    }
    
    // Mark Months TextField Changed
    @IBAction func marksMonthsTextFieldChanged(_ sender: NSTextField) {
        markerMonthsStepper.integerValue = sender.integerValue
        Settings.markerMonthsWidth = sender.integerValue
        updateUI()
    }
    
    // Reset Button Clicked
    @IBAction func resetDataParserButtonClicked(_ sender: NSButton) {
        Ephemeris.parser.resetParser()
        resetUI()
    }
    
    // Reset UI
    func resetUI() {
        uiState = .notParsed
        setupUI()
    }
    
    // Update Settings based on UI
    func updateUIFromSettings() {
        
    }
    
    // Update Settings based on UI
    func updateSettingsFromUI() {
        
        // Selected Date Range
        Settings.startDate = startDatePicker.dateValue
        Settings.endDate = endDatePicker.dateValue
        
        // Selected Option
        if let selectedPlanetOptionTitle = planetOptionPopupList.titleOfSelectedItem,
            let selectedPlanetOption = Settings.PlanetOption.from(title: selectedPlanetOptionTitle) {
            // Render All Options or Render Only Selected
            Settings.planetOption = selectedPlanetOption
        }
        
        // Selected Render Mode
        if let colorRenderModeTitle = colorRenderModePopupList.titleOfSelectedItem,
              let colorRenderMode = Timestream.ImageGenerator.ColorRenderMode.from(title: colorRenderModeTitle) {
            Settings.colorRenderMode = colorRenderMode
        }
        
        
        
    }
    
    // Clear Render Console
    func clearConsole() {
        renderConsoleTextField.stringValue = ""
    }
}

