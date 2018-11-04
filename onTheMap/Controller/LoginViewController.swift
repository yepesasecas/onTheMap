//
//  LoginViewController.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/3/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Mark: Actions
    
    @IBAction func logIn(_ sender: Any) {
        guard let email = emailTextField.text, email != "",
              let password = passwordTextField.text, password != ""  else {
            displayMessage(message: "Empty Email or Password.")
            return
        }
        
        let activityView = UIViewController.displaySpinner(onView: self.view)
        UdacityClient.sharedInstance().login(email: email, password: password) { (success, error) in
            DispatchQueue.main.async {
                UIViewController.removeSpinner(spinner: activityView)
                if success {
                    self.getCurrentUser()
                }
                else {
                    self.displayMessage(message: error!)
                }
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // Mark: Helpers
    
    func displayMessage(message: String) -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentUser() -> Void {
        let activityView = UIViewController.displaySpinner(onView: self.view)
        UdacityClient.sharedInstance().user(id: UdacityClient.sharedInstance().userID!) { (success, error) in
            DispatchQueue.main.async {
                UIViewController.removeSpinner(spinner: activityView)
                if success {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    self.present(controller, animated: true, completion: nil)
                }
                else{
                    self.displayMessage(message: error!)
                }
            }
        }
    }
}
