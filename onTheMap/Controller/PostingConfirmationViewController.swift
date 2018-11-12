//
//  PostingConfirmationViewController.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/11/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class PostingConfirmationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var placemark : CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let placemark = placemark {
            addPLacemark(placemark: placemark)
            setMapCenter(placemark: placemark)
        }
    }
    
    @IBAction func finish(_ sender: Any) {
    
        print("finish")
        
    }
    
    
    // Mark: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Mark: - Helpers
    
    func addPLacemark(placemark: CLPlacemark) -> Void {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: placemark.location?.coordinate.latitude ?? 0, longitude: placemark.location?.coordinate.longitude ?? 0)
        annotation.title = placemark.name
        mapView.addAnnotation(annotation)
        
    }
    
    func setMapCenter(placemark: CLPlacemark) -> Void {
        if let coordinate = placemark.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapView.setRegion(region, animated: false)
            return
        }
        print("Map Center: No center defined")
    }
}
