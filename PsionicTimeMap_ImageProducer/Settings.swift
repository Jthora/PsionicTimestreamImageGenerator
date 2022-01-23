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
    
    // Selected Planet Option
    static var planetOption: PlanetOption = .all {
        didSet {
            RenderLog.set(planetOption: planetOption)
        }
    }
    enum PlanetOption {
        case all
        case specific(planet: Timestream.Planet)
        
        var title: String {
            switch self {
            case .all: return "All"
            case .specific(let planet): return "\(planet.title)"
            }
        }
        
        func has(title:String) -> Bool {
            return self.title == title
        }
        
        static func from(title:String) -> PlanetOption? {
            if PlanetOption.all.has(title: title) {
                return PlanetOption.all
            }
            for planet in Timestream.Planet.allCases {
                let planetOption = PlanetOption.specific(planet: planet)
                if planetOption.has(title: title) { return planetOption }
            }
            return nil
        }
    }
    
    // Image Strip Generator Settings
    static var timestreams: Timestream.TimestreamSet? = nil
    
    static var colorRenderMode: Timestream.ImageGenerator.ColorRenderMode = .colorGradient {
        didSet {
            RenderLog.set(colorRenderMode: colorRenderMode)
        }
    }
    
    static var renderOption: Timestream.ImageGenerator.ColorRenderMode.RenderOption = .harmonics {
        didSet {
            RenderLog.set(renderOption: renderOption)
        }
    }
    
    static var markYears: Bool = false
    static var markMonths: Bool = false
    static var markerYearsWidth: Int = 2
    static var markerMonthsWidth: Int = 1
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
