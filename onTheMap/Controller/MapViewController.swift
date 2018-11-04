//
//  MapViewController.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/3/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // Mark: Helpers
    
    func displayMessage(message: String) -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
