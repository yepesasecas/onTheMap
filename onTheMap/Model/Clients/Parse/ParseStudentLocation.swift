//
//  ParseStudentLocation.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/4/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class ParseStudentLocation: NSObject {
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
    
    init(dictionary: [String: AnyObject?]) {
        objectId = dictionary["objectId"] as? String
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
    
    init(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: - functions
    
    func dict() -> [String:AnyObject?] {
        return [
            "uniqueKey": uniqueKey as AnyObject,
            "firstName": firstName as AnyObject,
            "lastName": lastName as AnyObject,
            "mapString": mapString as AnyObject,
            "mediaURL": mediaURL as AnyObject,
            "latitude": latitude as AnyObject,
            "longitude": longitude as AnyObject
        ]
    }
    
    func json() -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self.dict(), options: .sortedKeys)
            return data
        }
        catch  {
            return nil
        }
    }
    
    // MARK: - Class functions
    
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
