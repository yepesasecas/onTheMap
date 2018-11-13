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
        
        let parameters: [String: String] = [
            ParseConstants.ParameterKey.limit: "\(limit)",
            ParseConstants.ParameterKey.order: ParseConstants.ParameterValue.updatedAt
        ]
        let request = createURLRequest(method: ParseConstants.Method.get, path: ParseConstants.Path.studentLocation, parameters: parameters)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
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
    
    func createStudentLocation(studentLocation: ParseStudentLocation, completionHandler: @escaping (_ success: Bool, _ error: String?)-> Void) -> Void {
        let parameters: [String:String] = [:]
        var request = createURLRequest(method: ParseConstants.Method.post , path: ParseConstants.Path.studentLocation, parameters: parameters)
        request.addValue(ParseConstants.HeaderValue.applicationJson, forHTTPHeaderField: ParseConstants.HeaderKey.contentType)
        
        guard let json = studentLocation.json() else {
            print("unable to serialize objct to json")
            return
        }
        
        request.httpBody = json
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(false, "error creating Student Location: \(String(describing: error))")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                completionHandler(false, "expected statusCode == 201")
                return
            }
            
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    // MARK: - Functions
    
    func createURLRequest(method: String , path: String , parameters: [String:String]) -> URLRequest {
        var components = URLComponents()
        components.scheme = ParseConstants.URL.Scheme
        components.host = ParseConstants.URL.Host
        components.path = ParseConstants.Path.studentLocation
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method
        request.addValue(ParseConstants.AppID.value, forHTTPHeaderField: ParseConstants.AppID.key)
        request.addValue(ParseConstants.ApiKey.value, forHTTPHeaderField: ParseConstants.ApiKey.key)
        return request
    }
   
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
