//
//  InformationPostingViewController.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/5/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
        
        let activityView = UIViewController.displaySpinner(onView: self.view)
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            print("geocoder string: \(locationString)")
            print("geocoder placemarks:")
            print(placemarks ?? "...")
            
            
            DispatchQueue.main.async {
                UIViewController.removeSpinner(spinner: activityView)
                
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
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Keyboard
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        print("keyboard will show notification")
        if self.locationTextField.isFirstResponder || self.websiteTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification) * 1 / 3
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        print("keyboard will Hide notification")
        view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Functions
    
    func configure() -> Void {
        websiteTextField.delegate = self
        locationTextField.delegate = self
    }
}
