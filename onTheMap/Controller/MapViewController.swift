//
//  MapViewController.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/3/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var currentAnnotations: [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMapAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.removeAnnotations(self.currentAnnotations)
        self.updateMap(studentLocations: ParseClient.sharedInstance().studentLocations)
    }
    
    @IBAction func logout(_ sender: Any) {
        let activityView = UIViewController.displaySpinner(onView: self.view)
        UdacityClient.sharedInstance().logout() {(success, error) in
            DispatchQueue.main.async {
                UIViewController.removeSpinner(spinner: activityView)
                if success {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
                    self.present(loginViewController, animated: true, completion: nil)
                }
                else{
                    Helper.app.displayMessage(message: error!, vc: self)
                }
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        mapView.removeAnnotations(self.currentAnnotations)
        loadMapAnnotations()
    }
    
    // Mark: Functions
    
    func loadMapAnnotations() -> Void {
        let activityView = UIViewController.displaySpinner(onView: self.view)
        ParseClient.sharedInstance().getStudentLocations(limit: 100){ (success, studentLocations, error) in
            DispatchQueue.main.async {
                UIViewController.removeSpinner(spinner: activityView)
                if success {
                    self.updateMap(studentLocations: studentLocations as! [ParseStudentLocation])
                }
                else {
                    Helper.app.displayMessage(message: error!, vc: self)
                }
            }
        }
    }
    
    func updateMap(studentLocations: [ParseStudentLocation]) -> Void {
        studentLocations.forEach() { (sl) in
            let studentLocation = sl as ParseStudentLocation
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude ?? 0, longitude: studentLocation.longitude ?? 0)
            annotation.title = "\(studentLocation.firstName ?? "") \(studentLocation.lastName ?? "")"
            annotation.subtitle = "\(studentLocation.mediaURL ?? "")"
            currentAnnotations.append(annotation)
            mapView.addAnnotation(annotation)
        }
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle!, Helper.app.verifyUrl(urlString: toOpen) {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
