//
//  SelectLocationViewController.swift
//  Psionic Timestream Image Generator
//
//  Created by Jordan Trana on 1/16/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Cocoa
import MapKit

class SelectLocationViewController: NSViewController {
    
    // Map View UI
    @IBOutlet weak var mapView: LocationSelectMKMapView!
    @IBOutlet weak var searchBarTextField: NSTextField!
    
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var latitudeTextField: NSTextField!
    @IBOutlet weak var longitudeTextField: NSTextField!
    
    
    // Mouseclick Annotation
    let mouseclickAnnotationReuseIdentifier = "mouseclickAnnotationReuseIdentifier"
    lazy var mouseclickAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.coordinate = selectedCoordinate
        annotation.title = "Pinned Location"
        annotation.subtitle = "Lat:\(selectedCoordinate.latitude)\nLong:\(selectedCoordinate.longitude)"
        return annotation
    }()
    
    // Point Annotation View
    lazy var mouseclickAnnotationView: MKAnnotationView = {
        return MKAnnotationView(annotation: mouseclickAnnotation,
                                reuseIdentifier: mouseclickAnnotationReuseIdentifier)
    }()
    
    // Selected Coordinate Settings
    var selectedAnnotationView: MKAnnotationView? {
        get {
            return Settings.selectedAnnotationView
        }
        set {
            Settings.selectedAnnotationView = newValue
        }
    }
    
    var selectedAnnotation: MKAnnotation? {
        return Settings.selectedAnnotation
    }
    
    var selectedCoordinate: CLLocationCoordinate2D {
        return Settings.selectedCoordinate
    }
    
    
    // View Did Load
    override func viewDidLoad() {
        print("Select Location Screen Opened")
        
        // Map View Delegate
        mapView.delegate = self
        
        // 3D Globe - Hybrid
        mapView.mapType = .hybridFlyover
        
        // Set Map Viewport Center
        mapView.setCenter(selectedCoordinate, animated: false)
        
        // MapView Mouseclick Coordinate Callback
        mapView.selectedLocationCallback = { [weak self] coordinate in
            print("selectedLocationCallback")
            guard let strongSelf = self else {return}
            
            if !strongSelf.mapView.annotations.contains(where: { annotation in
                strongSelf.mouseclickAnnotation === annotation
            }) {
                strongSelf.mapView.addAnnotation(strongSelf.mouseclickAnnotation)
            }
            
            strongSelf.mapView.selectAnnotation(strongSelf.mouseclickAnnotation, animated: true)
            
            strongSelf.mouseclickAnnotation.coordinate = coordinate
            strongSelf.updateUI()
        }
    }
    
    // Select Location
    @IBAction func selectLocationButtonClicked(_ sender: NSButton) {
        print("Select Location Button Clicked")
        dismiss(self)
    }
    
    // Cancel Button
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        print("Cancel Button Clicked")
    }
    
    // Search Button
    @IBAction func searchButtonClicked(_ sender: NSButton) {
        print("Search Button Clicked")
        requestLocalSearch(naturalLanguageQuery)
    }
    
    var naturalLanguageQuery:String {
        return searchBarTextField.stringValue
    }
    
    @IBAction func searchTextField(_ sender: NSTextField) {
        print("Search Text Field: Engage")
        requestLocalSearch(naturalLanguageQuery)
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            // Update Mouseclick Annotation
            let lat = String(format: "%.2f", self.selectedCoordinate.latitude)
            let long = String(format: "%.2f", self.selectedCoordinate.longitude)
            self.mouseclickAnnotation.subtitle = "Lat:\(lat)\nLong:\(long)"
            
            switch Settings.coordinateSource {
            case .manual:
                self.nameTextField.stringValue = "Manual Coordinates"
            case .map:
                if let name = self.selectedAnnotation?.title ?? "Pinned Location" as String {
                    self.nameTextField.stringValue = "\(name) [SELECTED]"
                } else {
                    self.nameTextField.stringValue = "Pinned Location"
                }
            case .unset:
                self.nameTextField.stringValue = "Default Coordinates"
            }
            self.latitudeTextField.stringValue = "\(lat)º" //"0.0º"
            self.longitudeTextField.stringValue = "\(long)º" //"0.0º"
        }
    }
    
    // Use MapKit Local Search to update displayed Coordinates
    func requestLocalSearch(_ naturalLanguageQuery:String) {
        print("Request Local Search:: naturalLanguageQuery: \(naturalLanguageQuery)")
        
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let viewRegion = MKCoordinateRegion(center: selectedCoordinate, span: span)
        
        // Bounding Region
        var boundingRegion: MKCoordinateRegion? = nil
        
        // POI Requests
        let poiRequest = MKLocalSearch.Request()
        poiRequest.naturalLanguageQuery = naturalLanguageQuery
        poiRequest.region = viewRegion
        poiRequest.resultTypes = .pointOfInterest
        
        // POI Search
        let poiSearch = MKLocalSearch(request: poiRequest)
        poiSearch.start { [weak self] response, error in
            if let response = response {
                print("POI Search Response: response.mapItems.count \(response.mapItems.count)")
                self?.addNewPOIs(response.mapItems)
                
                self?.mapView.setRegion(response.boundingRegion , animated: true)
            }
            if let error = error {
                print(error)
                print("POI Search Response: ERROR \(error.localizedDescription)")
            }
        }
        
        // Address Requests
        let addressRequest = MKLocalSearch.Request()
        addressRequest.naturalLanguageQuery = naturalLanguageQuery
        addressRequest.region = viewRegion
        addressRequest.resultTypes = .address
        
        // Address Search
        let addressSearch = MKLocalSearch(request: addressRequest)
        addressSearch.start { [weak self] response, error in
            if let response = response {
                print("Address Search Response: response.mapItems.count \(response.mapItems.count)")
                self?.addNewAddresses(response.mapItems)
                
            }
            if let error = error {
                print("Address Search Response: ERROR \(error.localizedDescription)")
            }
        }
        
    }
    
    // POI Map Annotations
    var mapPOIs:[MKMapItem] = []
    var mapPOIAnnotations:[MKPointAnnotation] = []
    var primaryPOIAnnotation: MKPointAnnotation? {
        return mapPOIAnnotations.first
    }
    
    // Add New POI(s)
    func addNewPOIs(_ mapItems:[MKMapItem]) {
        print("Add New POI(s)")
        
        // Reset Annotations
        for oldAnnotation in mapPOIAnnotations {
            mapView.removeAnnotation(oldAnnotation)
        }
        mapPOIAnnotations.removeAll()
        mapPOIs = mapItems
        
        // Create and Add Annotations
        for mapPOI in mapPOIs {
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapPOI.placemark.coordinate
            annotation.title = mapPOI.name ?? mapPOI.placemark.title ?? "Point of Interest"
            annotation.subtitle = ""//"Lat:\(selectedCoordinate.latitude)\nLong:\(selectedCoordinate.longitude)"
            mapPOIAnnotations.append(annotation)
            mapView.addAnnotation(annotation)
            print("POI: annotation.title\(annotation.title) | ")
        }
        
    }
    
    // Address Map Annotations
    var mapAddresses:[MKMapItem] = []
    var mapAddressAnnotations:[MKPointAnnotation] = []
    var primaryAddressAnnotation: MKPointAnnotation? {
        return mapAddressAnnotations.first
    }
    
    // Add New Address(s)
    func addNewAddresses(_ mapItems:[MKMapItem]) {
        print("Add New Address(s)")
        
        // Reset Annotations
        for oldAnnotation in mapAddressAnnotations {
            mapView.removeAnnotation(oldAnnotation)
        }
        mapAddressAnnotations.removeAll()
        mapAddresses = mapItems
        
        // Create and Add Annotations
        for mapAddress in mapAddresses {
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedCoordinate
            annotation.title = mapAddress.name ?? mapAddress.placemark.title ?? "Address"
            annotation.subtitle = ""//"Lat:\(selectedCoordinate.latitude)\nLong:\(selectedCoordinate.longitude)"
            mapAddressAnnotations.append(annotation)
            mapView.addAnnotation(annotation)
        }
    }
    
    // Update Map
    func updateMap() {
        
    }
}

extension SelectLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let title : String? = view.annotation?.title ?? "?"
        print("MapView:: didSelect: \(title ?? "?")")
        
        guard let pointAnnotation = view.annotation as? MKPointAnnotation else { return }
        
        Settings.selectedAnnotationView = view
        if let _ = Settings.mapCoordinate {
            Settings.resetManualLatitudeLongitude()
        }
        
        DispatchQueue.main.async {
            let lat = String(format: "%.2f", self.selectedCoordinate.latitude)
            let long = String(format: "%.2f", self.selectedCoordinate.longitude)
            pointAnnotation.subtitle = "Lat:\(lat)º\nLong:\(long)º"
            
            self.updateUI()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let pointAnnotation = view.annotation as? MKPointAnnotation else { return }
        pointAnnotation.subtitle = ""
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        guard annotation is MKPointAnnotation else {
            return nil
        }

        // Reuse Standard Annotations
        let identifier = "standardAnnotationIdentifier"
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation
            return annotationView
        }
        
        // Create New Standard Annotations
        let annotationView: MKAnnotationView
        if #available(macOS 11.0, *) {
            if annotation.subtitle != nil && annotation.subtitle??.count ?? 0 > 0 {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
        } else {
            // Fallback on earlier versions
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView.canShowCallout = true
        annotationView.annotation = annotation
        return annotationView
    }
}

