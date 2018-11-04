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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseClient.sharedInstance().getStudentLocations(limit: 100){ (success, studentLocations, error) in
            DispatchQueue.main.async {
                if success {
                    self.updateMap(studentLocations: studentLocations as! [ParseStudentLocation])
                }
                else {
                    self.displayMessage(message: error!)
                }
            }
        }
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
                    self.displayMessage(message: error!)
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
            
            mapView.addAnnotation(annotation)
        }
    }
    
    // Mark: Helpers
    
    func displayMessage(message: String) -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
