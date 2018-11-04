//
//  ParseStudentLocation.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/4/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class ParseStudentLocation: NSObject {
    
    let objectId: String
    let uniqueKey: String?
    var firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String?
    let updatedAt: String?
    
    init(dictionary: [String: AnyObject?]) {
        objectId = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        createdAt = dictionary["createdAt"] as? String
        updatedAt = dictionary["updatedAt"] as? String
    }
    
    class func parseDataToStudentLocations(dictionary: [String: AnyObject?]) -> [ParseStudentLocation] {
        var studentLocations = [ParseStudentLocation]()
        
        if let results = dictionary["results"] as? [AnyObject?]{
            results.forEach() {
                studentLocations.append(ParseStudentLocation(dictionary: $0 as! [String : AnyObject?]))
            }
        }
        return studentLocations
    }
}
