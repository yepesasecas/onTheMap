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
        
        guard let urlString = self.websiteTextField.text, self.verifyUrl(urlString: urlString) else {
            self.displayMessage(message: "Invalid URL. add http://...")
            return
        }
        
        guard let locationString = self.locationTextField.text, locationString != "" else {
            self.displayMessage(message: "Location Empty")
            return
        }
        
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            print("geocoder string: \(locationString)")
            print("geocoder placemarks:")
            print(placemarks ?? "...")
            
            
            DispatchQueue.main.async {
                if error != nil {
                    print("geocoder error: \(String(describing: error))")
                    self.displayMessage(message: "Unable to find location")
                    return
                }
                
                let postingConfirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "postingConfirmation") as! PostingConfirmationViewController
                postingConfirmationVC.placemark = placemarks?.first
                self.navigationController?.pushViewController(postingConfirmationVC, animated: true)
            }
        }
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Mark: - Helpers
    
    func displayMessage(message: String) -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
}
