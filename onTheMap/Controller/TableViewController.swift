//
//  TableViewController.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/4/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func refresh(_ sender: Any) {
        loadTableAnnotations()
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
    
    // MARK: - Functions
    
    func loadTableAnnotations() -> Void {
        let activityView = UIViewController.displaySpinner(onView: self.view)
        ParseClient.sharedInstance().getStudentLocations(limit: 100){ (success, studentLocations, error) in
            DispatchQueue.main.async {
                UIViewController.removeSpinner(spinner: activityView)
                if success {
                    self.tableView.reloadData()
                }
                else {
                    Helper.app.displayMessage(message: error!, vc: self)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentLocation = ParseClient.sharedInstance().studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationCell", for: indexPath)
        
        cell.textLabel?.text = "\(studentLocation.firstName ?? "") \(studentLocation.lastName ?? "")"
        cell.detailTextLabel?.text = studentLocation.mediaURL
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = ParseClient.sharedInstance().studentLocations[indexPath.row]
        if let mediaURL = studentLocation.mediaURL, Helper.app.verifyUrl(urlString: mediaURL) {
            UIApplication.shared.open(URL(string: mediaURL)!, options: [:], completionHandler: nil)
        }
    }
}
