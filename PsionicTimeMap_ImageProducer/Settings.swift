//
//  Settings.swift
//  Psionic Timestream Image Generator
//
//  Created by Jordan Trana on 1/16/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Foundation
import MapKit
import Combine

struct Settings {
    
    // Timestreams
    /// Image Strip Generator Settings
    static var timestreams: Timestream.TimestreamSet? = nil
    
    // Planet Option
    /// Selected Planet Option
    static var planetOption: PlanetOption = .all {
        didSet {
            RenderLog.set(planetOption: planetOption)
        }
    }
    enum PlanetOption {
        case all
        case list(planets: Timestream.PlanetList)
        case specific(planet: Timestream.Planet)
        
        var title: String {
            switch self {
            case .all: return "All Planets"
            case .list: return "Multiple"
            case .specific(let planet): return "\(planet.title)"
            }
        }
        
        func has(title:String) -> Bool {
            return self.title == title
        }
        
        var planets:Timestream.PlanetList {
            switch self {
            case .all: return Timestream.Planet.allCases
            case .list(let planet): return planet
            case .specific(let planet): return [planet]
            }
        }
        
        static func from(title:String, planets: Timestream.PlanetList = []) -> PlanetOption? {
            if PlanetOption.all.has(title: title) {
                return PlanetOption.all
            }
            for planet in Timestream.Planet.allCases {
                let planetOption = PlanetOption.specific(planet: planet)
                if planetOption.has(title: title) { return planetOption }
            }
            if PlanetOption.list(planets: planets).has(title: title) {
                return PlanetOption.list(planets: planets)
            }
            return nil
        }
    }
    
    // Color Render Mode Option
    /// Selected Color Render Mode Option
    static var colorRenderModeOption: ColorRenderModeOption = .all {
        didSet {
            RenderLog.set(colorRenderMode: colorRenderModeOption)
        }
    }
    enum ColorRenderModeOption {
        case all
        case list(colorRenderModes: Timestream.ImageGenerator.ColorRenderModeList)
        case specific(colorRenderMode: Timestream.ImageGenerator.ColorRenderMode)
        
        var title: String {
            switch self {
            case .all: return "All Color Modes"
            case .list: return "Multiple"
            case .specific(let colorRenderMode): return "\(colorRenderMode.title)"
            }
        }
        
        func has(title:String) -> Bool {
            return self.title == title
        }
        
        var colorRenderModes:Timestream.ImageGenerator.ColorRenderModeList {
            switch self {
            case .all: return Timestream.ImageGenerator.ColorRenderMode.allCases
            case .list(let colorRenderModes): return colorRenderModes
            case .specific(let colorRenderMode): return [colorRenderMode]
            }
        }
        
        static func from(title:String, colorRenderModes: Timestream.ImageGenerator.ColorRenderModeList = []) -> ColorRenderModeOption? {
            if ColorRenderModeOption.all.has(title: title) {
                return ColorRenderModeOption.all
            }
            for colorRenderMode in Timestream.ImageGenerator.ColorRenderMode.allCases {
                let colorRenderModeOption = ColorRenderModeOption.specific(colorRenderMode: colorRenderMode)
                if colorRenderModeOption.has(title: title) { return colorRenderModeOption }
            }
            if ColorRenderModeOption.list(colorRenderModes: colorRenderModes).has(title: title) {
                return ColorRenderModeOption.list(colorRenderModes: colorRenderModes)
            }
            return nil
        }
    }
    
    // Data Metric Option
    /// Selected Data Metric Option
    static var dataMetricOption: DataMetricOption = .all {
        didSet {
            RenderLog.set(dataMetric: dataMetricOption)
        }
    }
    enum DataMetricOption {
        case all
        case list(dataMetrics: Timestream.ImageGenerator.ColorRenderMode.DataMetricList)
        case specific(dataMetric: Timestream.ImageGenerator.ColorRenderMode.DataMetric)
        
        var title: String {
            switch self {
            case .all: return "All Data Metrics"
            case .list: return "Multiple Data Metrics"
            case .specific(let renderOption): return "\(renderOption.title)"
            }
        }
        
        func has(title:String) -> Bool {
            return self.title == title
        }
        
        var dataMetrics:Timestream.ImageGenerator.ColorRenderMode.DataMetricList {
            switch self {
            case .all: return Timestream.ImageGenerator.ColorRenderMode.DataMetric.allCases
            case .list(let dataMetrics): return dataMetrics
            case .specific(let dataMetric): return [dataMetric]
            }
        }
        
        static func from(title:String, dataMetrics: Timestream.ImageGenerator.ColorRenderMode.DataMetricList = []) -> DataMetricOption? {
            if DataMetricOption.all.has(title: title) {
                return DataMetricOption.all
            }
            for dataMetric in Timestream.ImageGenerator.ColorRenderMode.DataMetric.allCases {
                if dataMetric.has(title: title) {
                    return DataMetricOption.specific(dataMetric: dataMetric)
                }
            }
            if DataMetricOption.list(dataMetrics: dataMetrics).has(title: title) {
                return DataMetricOption.list(dataMetrics: dataMetrics)
            }
            return nil
        }
    }
    
    // Markings
    static var markYears: Bool = false
    static var markMonths: Bool = false
    static var markerYearsWidth: Int = 2
    static var markerMonthsWidth: Int = 1
    
    // Filename
    static var filenamePrefix: String = "timestream"
    
    // Sample Density
    static var sampleDensity: Int? = nil
    static let defaultSampleDensity: Int = 4096
    static var sampleDensityString: String? {
        return sampleDensity == nil ? nil : "\(sampleDensity! == 0 ? "" : "\(sampleDensity!)")"
    }
    
    // Dates
    static var startDate: Date = Ephemeris.minDate
    static var endDate: Date = Ephemeris.maxDate
    static var days: Int { return Int(Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0) }
    
    // Manual Latitude and Longitude
    static var manualLongitude: CLLocationDegrees? = nil
    static var manualLongitudeString: String? {
        return manualLongitude == nil ? nil : "\(manualLongitude! == 0 ? "" : "\(manualLongitude!)")"
    }
    static var manualLatitude: CLLocationDegrees? = nil
    static var manualLatitudeString: String? {
        return manualLatitude == nil ? nil : "\(manualLatitude! == 0 ? "" : "\(manualLatitude!)")"
    }
    
    // Parser Data Source
    static var parserDataSource: ParserDataSource = .database
    enum ParserDataSource {
        case database
        case coreAstrology
    }
    
    // Current Coordinates Source
    static var coordinateSource: CoordinateSource {
        if let _ = Settings.manualCoordinate {
            return .manual
        } else if let _ = Settings.mapCoordinate {
            return .map
        } else {
            return .unset
        }
    }
    
    // Coordinate Source
    enum CoordinateSource {
        case manual
        case map
        case unset
    }
    
    // Selected Coordinate
    static var selectedCoordinate: CLLocationCoordinate2D {
        return manualCoordinate ?? mapCoordinate ?? defaultCoordinate
    }
    
    // Selected Annotation
    static var selectedAnnotationView: MKAnnotationView? = nil
    static var selectedAnnotation: MKAnnotation? {
        return selectedAnnotationView?.annotation
    }
    
    // Map Coordinate, Longitude and Latitude
    static var mapCoordinate: CLLocationCoordinate2D? {
        return selectedAnnotation?.coordinate
    }
    static var mapLatitudeString: String? {
        return mapCoordinate?.latitude == nil ? nil : "\(mapCoordinate!.latitude == 0 ? "" : "\(mapCoordinate!.latitude)")"
    }
    static var mapLongitudeString: String? {
        return mapCoordinate?.longitude == nil ? nil : "\(mapCoordinate!.longitude == 0 ? "" : "\(mapCoordinate!.longitude)")"
    }
    
    // Manual Reset
    static func resetManualLatitudeLongitude() {
        manualLatitude = nil
        manualLongitude = nil
    }
    
    // Manual Coordinate
    static var manualCoordinate: CLLocationCoordinate2D? {
        if manualLongitude != nil || manualLatitude != nil {
            return CLLocationCoordinate2D(latitude: manualLatitude ?? 0, longitude: manualLongitude ?? 0)
        } else {
            return nil
        }
    }
    
    // Default Coordinate
    static let defaultCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    
    // What calculations and values are used to determine and render
    /// Planet Option and Render Option
    enum TimestreamFormatOption {
        case PlanetaryDistance
        case AbsoluteGravimetricFieldStrength
        case GravimetricFieldStrength
    }
}
