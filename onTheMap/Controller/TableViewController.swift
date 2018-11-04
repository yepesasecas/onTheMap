//
//  TableViewController.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/4/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var studentLocations: [ParseStudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        studentLocations = ParseClient.sharedInstance().studentLocations
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentLocation = self.studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationCell", for: indexPath)
        
        cell.textLabel?.text = "\(studentLocation.firstName ?? "") \(studentLocation.lastName ?? "")"
        cell.detailTextLabel?.text = studentLocation.mediaURL
        
        return cell
    }
}
