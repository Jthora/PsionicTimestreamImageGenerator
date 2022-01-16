//
//  SelectLocationViewController.swift
//  Psionic Timestream Image Generator
//
//  Created by Jordan Trana on 1/16/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Cocoa
import MapKit

class SelectLocationViewController: ViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBarTextField: NSTextField!
    
    var selectedCoordinate:CLLocationCoordinate2D {
    }
    
    override func viewDidLoad() {
        print("Select Location Screen Opened")
        mapView.setCenter(CLLocationCoordinate2D(latitude: 0, longitude: 0), animated: false)
    }
    
    @IBAction func selectLocationButtonClicked(_ sender: NSButton) {
        print("Select Location Button Clicked")
        // Set StarKit Location
        
        // mapView.centerCoordinate
        
    }
    
    @IBAction func searchButtonClicked(_ sender: NSButton) {
        print("Search Button Clicked")
    }
}

extension SelectLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.annotation?.coordinate
    }
    
}
