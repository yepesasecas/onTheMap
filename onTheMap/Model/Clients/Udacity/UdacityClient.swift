//
//  UdacityClient.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/3/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var sessionID: String? = nil
    var userID: String? = nil
    var currentUser: UdacityUser? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }

    // MARK: functions
    
    func login(email: String, password: String, completionHandler: @escaping (_ result: Bool, _ error: String?) -> Void) -> Void {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)

        let task = session.dataTask(with: request) { data, response, error in
            guard let parsedData = self.parseData(data: data, response: response, error: error, completionHandler: completionHandler) else {
                return
            }
            
            if let status = parsedData["status"] as? Int, status == 403  {
                completionHandler(false, parsedData["error"] as? String)
                return
            }
            
            if let session = parsedData["session"] as? [String : AnyObject],
                let sessionId = session["id"] as? String,
                let account = parsedData["account"] as? [String : AnyObject],
                let accountKey = account["key"] as? String {
                    self.sessionID = sessionId
                    self.userID = accountKey
                    print("current User session: \(self.sessionID!)")
                    print("current User id: \(self.userID!)")
                    completionHandler(true, "")
                    return
            }
            
            completionHandler(false, "try again.")
        }
        task.resume()
    }
    
    func logout(completionHandler: @escaping (_ result: Bool, _ error: String?) -> Void) -> Void {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(false, "unable to logout. try again.")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print("logout session: \(self.sessionID!)")
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    func user(id: String, completionHandler: @escaping (_ result: Bool, _ error: String?) -> Void) -> Void {
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(id)")!)
        let task = session.dataTask(with: request) { data, response, error in
            guard let parsedData = self.parseData(data: data, response: response, error: error, completionHandler: completionHandler) else {
                return
            }
            self.currentUser = UdacityUser.init(dictionary: parsedData as! [String : AnyObject?])
            print("current User: \(self.currentUser!.firstName!) \(self.currentUser!.id!)")
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    func parseData(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (_ result: Bool, _ error: String?) -> Void) -> AnyObject? {
        if error != nil {
            completionHandler(false, error.debugDescription)
            return nil
        }
        
        guard let data = data  else {
            print("no data returned")
            completionHandler(false, "unable to get user info")
            return nil
        }
        
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range) /* subset response data! */
        
        var parsedData: AnyObject! = nil
        do{
            parsedData =  try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        }
        catch {
            print("unable to parse json \(String(data: newData, encoding: .utf8)!)")
            completionHandler(false, "unable to get user info")
            return nil
        }
        
        return parsedData
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
