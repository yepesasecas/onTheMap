//
//  User.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/4/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class UdacityUser: NSObject {
    var firstName: String? = nil
    var lastName: String? = nil
    var id: String? = nil
    var nickname: String? = nil
    
    init(dictionary: [String: AnyObject?]) {
        print(dictionary)
        if let userData = dictionary["user"] as? [String: AnyObject?],
           let TFirstName = userData["first_name"] as? String,
           let TLastName = userData["last_name"] as? String,
           let TUserID = userData["key"] as? String,
           let TNickname = userData["nickname"] as? String {
            self.firstName = TFirstName
            self.lastName = TLastName
            self.id = TUserID
            self.nickname = TNickname
        }
    }
    
    func name() -> String {
        return firstName ?? nickname ?? "no available name"
    }
}
