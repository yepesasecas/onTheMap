//
//  ParseConstants.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/12/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class ParseConstants: NSObject {
    
    struct Method {
        static let get: String = "GET"
        static let post: String = "POST"
    }
    
    struct URL {
        static let Scheme: String = "https"
        static let Host: String = "parse.udacity.com"
    }
    
    struct Path {
        static let studentLocation = "/parse/classes/StudentLocation"
    }
    
    struct ApiKey {
        static let key = "X-Parse-REST-API-Key"
        static let value = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct AppID {
        static let key = "X-Parse-Application-Id"
        static let value = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    struct ParameterKey {
        static let limit = "limit"
        static let order = "order"
    }
    
    struct ParameterValue {
        static let updatedAt = "-updatedAt"
    }
    
    struct HeaderKey {
        static let contentType = "Content-Type"
    }
    
    struct HeaderValue {
        static let applicationJson = "application/json"
    }
    
}
