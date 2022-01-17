//
//  LocationSelectMKMapView.swift
//  Psionic Timestream Image Generator
//
//  Created by Jordan Trana on 1/16/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Cocoa
import MapKit

typealias LocationSelectMKMapViewCallback = ((_ coordinate:CLLocationCoordinate2D)->())

class LocationSelectMKMapView: MKMapView {
    
    
    var selectedLocationCallback: LocationSelectMKMapViewCallback? = nil
    
    override func mouseDown(with event: NSEvent) {
        
        // Detect Double Click
        if event.clickCount > 1 {
            print("LocationSelectMKMapView DoubleClick")
            //let point = convert(event.locationInWindow, to: nil)
            let coordinate = convert(event.locationInWindow, toCoordinateFrom: nil)
            selectedLocationCallback?(coordinate)
        }
        
        super.mouseDown(with: event)
    }
}
