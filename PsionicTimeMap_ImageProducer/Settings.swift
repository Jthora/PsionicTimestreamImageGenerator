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
    
    // Sample Density
    static var sampleDensity: Int? = nil
    static let defaultSampleDensity: Int = 4096
    static var sampleDensityString: String? {
        return sampleDensity == nil ? nil : "\(sampleDensity! == 0 ? "" : "\(sampleDensity!)")"
    }
    
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
    
    // Coordinates Source
    static var coordinateSource: CoordinateSource {
        if let _ = Settings.manualCoordinate {
            return .manual
        } else if let _ = Settings.mapCoordinate {
            return .map
        } else {
            return .unset
        }
    }
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
    
    
}
