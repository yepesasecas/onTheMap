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
        if let locationString = locationTextField.text {
            geocoder.geocodeAddressString(locationString) { (placemarks, error) in
                print(error)
                print(placemarks)
            }
        }
    }
}
