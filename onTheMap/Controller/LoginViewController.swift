//
//  LoginViewController.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/3/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        if self.passwordTextField.isFirstResponder || self.emailTextField.isFirstResponder {
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
    
    func configure() -> Void {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}
