//
//  Helper.swift
//  onTheMap
//
//  Created by Andres Yepes on 11/12/18.
//  Copyright © 2018 Andres Yepes. All rights reserved.
//

import UIKit

class Helper: NSObject {
    static var app: Helper {
        return Helper()
    }
    
    func displayMessage(message: String, vc: UIViewController) -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func verifyUrl(urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}
