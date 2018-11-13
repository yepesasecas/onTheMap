//
//  InformationPostingViewController.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/5/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        guard let urlString = self.websiteTextField.text, Helper.app.verifyUrl(urlString: urlString) else {
            Helper.app.displayMessage(message: "Invalid URL. add http://...", vc: self)
            return
        }
        
        guard let locationString = self.locationTextField.text, locationString != "" else {
            Helper.app.displayMessage(message: "Location Empty", vc: self)
            return
        }
        
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            print("geocoder string: \(locationString)")
            print("geocoder placemarks:")
            print(placemarks ?? "...")
            
            
            DispatchQueue.main.async {
                if error != nil {
                    print("geocoder error: \(String(describing: error))")
                    Helper.app.displayMessage(message: "Unable to find location", vc: self)
                    return
                }
                
                let postingConfirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "postingConfirmation") as! PostingConfirmationViewController
                postingConfirmationVC.placemark = placemarks?.first
                postingConfirmationVC.mediaURL = urlString
                self.navigationController?.pushViewController(postingConfirmationVC, animated: true)
            }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
