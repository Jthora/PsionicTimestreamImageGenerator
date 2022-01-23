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
    @IBOutlet weak var dataMetricPopupList: NSPopUpButton!
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
                self.dataMetricPopupList.isEnabled = false
                
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
                self.dataMetricPopupList.isEnabled = false
                
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
                self.dataMetricPopupList.isEnabled = true
                
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
        renderConsoleTextField.toolTip = "Log Console"
        
        // Clear Popup Lists
        planetOptionPopupList.removeAllItems()
        colorRenderModePopupList.removeAllItems()
        dataMetricPopupList.removeAllItems()
        
        // Add an "All" Option for Auto-generating image strips for each available option
        planetOptionPopupList.addItem(withTitle: Settings.PlanetOption.all.title)
        colorRenderModePopupList.addItem(withTitle: Settings.ColorRenderModeOption.all.title)
        dataMetricPopupList.addItem(withTitle: Settings.DataMetricOption.all.title)
        
//        TODO:: Support Lists of Options
//        // Add a "Multiple" Option for Auto-generating image strips for a list of selected options
//        planetOptionPopupList.addItem(withTitle: Settings.PlanetOption.all.title)
//        colorRenderModePopupList.addItem(withTitle: Settings.ColorRenderModeOption.all.title)
//        renderOptionPopupList.addItem(withTitle: Settings.RenderOption.all.title)
        
        // Add Planets as Options
        for planet in Timestream.Planet.allCases {
            planetOptionPopupList.addItem(withTitle: Settings.PlanetOption.specific(planet: planet).title)
        }
        
        // Add an Option for each Planet
        for colorRenderMode in Timestream.ImageGenerator.ColorRenderMode.allCases {
            colorRenderModePopupList.addItem(withTitle: colorRenderMode.title)
        }
        
        // Add an Option for each Planet
        for renderOption in Timestream.ImageGenerator.ColorRenderMode.DataMetric.allCases {
            dataMetricPopupList.addItem(withTitle: renderOption.title)
        }
        
        // Preselection First Option "All"
        planetOptionPopupList.selectItem(at: 0)
        colorRenderModePopupList.selectItem(at: 0)
        dataMetricPopupList.selectItem(at: 0)
        
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
        
        // Planet
        let examplePlanet:Timestream.Planet
        switch Settings.planetOption {
        case .all: examplePlanet = .sun
        case .list(let planets): examplePlanet = planets.first ?? .sun
        case .specific(let planet): examplePlanet = planet
        }
        
        // Color Render Mode
        let exampleColorRenderMode:Timestream.ImageGenerator.ColorRenderMode
        switch Settings.colorRenderModeOption {
        case .all: exampleColorRenderMode = .colorGradient
        case .list(let colorRenderModes): exampleColorRenderMode = colorRenderModes.first ?? .colorGradient
        case .specific(let colorRenderMode): exampleColorRenderMode = colorRenderMode
        }
        
        // Data Metric
        let exampleDataMetric:Timestream.ImageGenerator.ColorRenderMode.DataMetric
        switch Settings.dataMetricOption {
        case .all: exampleDataMetric = .harmonics
        case .list(let renderOptions): exampleDataMetric = renderOptions.first ?? .harmonics
        case .specific(let renderOption): exampleDataMetric = renderOption
        }
        
        let filenameExample:String = Timestream.ImageStrip.createFilename(filenamePrefix: Settings.filenamePrefix,
                                                                          planet: examplePlanet,
                                                                          colorRenderMode: exampleColorRenderMode,
                                                                          dataMetric: exampleDataMetric,
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
        
        // Log that Parser Started
        DispatchQueue.main.async {
            RenderLog.parseStart()
        }
        
        // Set UI
        uiState = .parsing
        
        // Parse from Start Date to End Date
        Ephemeris.parser.parse(from: startDatePicker.dateValue,
                                       to: endDatePicker.dateValue) {  [weak self] percentComplete in
            DispatchQueue.main.async {
                // Set Percent Complete (0 to 1)
                self?.parseProgressIndicator.doubleValue = percentComplete
            }
        } onComplete: { [weak self] timestreams,entriesCount  in
            Settings.timestreams = timestreams
            DispatchQueue.main.async {
                // Set to Full
                RenderLog.parseComplete("created \(timestreams.count) timestreams\nparsed \(entriesCount) entries")
                self?.uiState = .parsed
            }
        }
    }
    
    // Generate & Save PNG Image Strip
    @IBAction func generateButtonPressed(_ sender: NSButton) {
        // Generate Image Strip for Every Planet
        guard let timestreams = Settings.timestreams else {
            RenderLog.error("Timestreams missing")
            return
        }
        
        let colorRenderModes = Settings.colorRenderModeOption.colorRenderModes
        let dataMetrics = Settings.dataMetricOption.dataMetrics
        
        Timestream.ImageGenerator.saveMultipleToDisk(timestreams: timestreams,
                                                     colorRenderModes: colorRenderModes,
                                                     dataMetrics: dataMetrics,
                                                     markYears: Settings.markYears,
                                                     markMonths: Settings.markMonths,
                                                     markerYearsWidth: Settings.markerYearsWidth,
                                                     markerMonthsWidth: Settings.markerMonthsWidth,
                                                     filenamePrefix: Settings.filenamePrefix,
                                                     startDate: Settings.startDate,
                                                     endDate: Settings.endDate)
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
        
        guard let dataMetricOption = Settings.DataMetricOption.from(title: renderOptionTitle) else {
            print("ERROR:: onSelectRenderOption:\n Title Selected is NOT a Render Mode")
            return
        }
        
        Settings.dataMetricOption = dataMetricOption
        updateUI()
    }
    
    // Render Option Selected
    @IBAction func onSelectColorRenderMode(_ sender: NSPopUpButton) {
        print("Render Option Selected: \(sender.titleOfSelectedItem ?? "??")")
        
        guard let colorRenderModeTitle = sender.titleOfSelectedItem else {
            print("ERROR:: onSelectRenderOption:\n Nil Title Selected?")
            return
        }
        
        guard let colorRenderModeOption = Settings.ColorRenderModeOption.from(title: colorRenderModeTitle) else {
            print("ERROR:: onSelectRenderOption:\n Title Selected is NOT a Render Mode")
            return
        }
        
        Settings.colorRenderModeOption = colorRenderModeOption
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
        planetOptionPopupList.selectItem(withTitle: Settings.planetOption.title)
        colorRenderModePopupList.selectItem(withTitle: Settings.colorRenderModeOption.title)
        dataMetricPopupList.selectItem(withTitle: Settings.dataMetricOption.title)
    }
    
    // Update Settings based on UI
    func updateSettingsFromUI() {
        
        // Selected Date Range
        Settings.startDate = startDatePicker.dateValue
        Settings.endDate = endDatePicker.dateValue
        
        // Selected Option
        if let planetOptionTitle = planetOptionPopupList.titleOfSelectedItem,
            let planetOption = Settings.PlanetOption.from(title: planetOptionTitle) {
            Settings.planetOption = planetOption
        }
        
        // Selected Color Render Mode
        if let colorRenderModeTitle = colorRenderModePopupList.titleOfSelectedItem,
              let colorRenderModeOption = Settings.ColorRenderModeOption.from(title: colorRenderModeTitle) {
            Settings.colorRenderModeOption = colorRenderModeOption
        }
        
        // Selected Render Option
        if let dataMetricTitle = colorRenderModePopupList.titleOfSelectedItem,
              let dataMetricOption = Settings.DataMetricOption.from(title: dataMetricTitle) {
            Settings.dataMetricOption = dataMetricOption
        }
    }
    
    // Clear Render Console
    func clearConsole() {
        renderConsoleTextField.stringValue = ""
    }
}

