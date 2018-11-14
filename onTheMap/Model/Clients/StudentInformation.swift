//
//  StudentInformation.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/13/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class StudentInformation: NSObject {
    
    // MARK: - Proporty
    
    var studentsInformation : [ParseStudentLocation] = []
    
    // MARK: - Initializer
    
    override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> StudentInformation {
        struct Singleton {
            static var sharedInstance = StudentInformation()
        }
        return Singleton.sharedInstance
    }
}
