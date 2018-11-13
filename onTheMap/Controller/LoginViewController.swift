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
                Helper.app.displayMessage(message: "Empty Email or Password.", vc: self)
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
                    Helper.app.displayMessage(message: error!, vc: self)
                }
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // Mark: Function
    
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
                    Helper.app.displayMessage(message: error!, vc: self)
                }
            }
        }
    }
}
