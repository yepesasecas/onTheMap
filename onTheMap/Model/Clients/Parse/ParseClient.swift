//
//  ParseClient.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/4/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    // MARK: Properties
    var studentLocations: [ParseStudentLocation] = []
    var session = URLSession.shared
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Public
    
    func getStudentLocations(limit: Int, completionHandler: @escaping (_ success: Bool, _ studentLocations: AnyObject?, _ error: String?)-> Void) -> Void {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=\(limit)&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            guard let data = data else {
                print("no data returned")
                return
            }
            
            var parsedData: AnyObject! = nil
            do{
                parsedData =  try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            }
            catch {
                print("unable to parse json \(String(data: data, encoding: .utf8)!)")
                return
            }
            
            self.studentLocations = ParseStudentLocation.parseDataToStudentLocations(dictionary: parsedData as! [String : AnyObject?])
            completionHandler(true, self.studentLocations as AnyObject, nil)
            
        }
        task.resume()
    }
    
    func createStudentLocation(studentLocation: ParseStudentLocation, completionHandler: @escaping (_ success: Bool, _ studentLocations: AnyObject?, _ error: String?)-> Void) -> Void {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
