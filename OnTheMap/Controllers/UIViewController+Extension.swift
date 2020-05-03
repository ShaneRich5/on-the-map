//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Shane Richards on 5/2/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func displayDefaultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func getApplicationDelegate() -> AppDelegate {
        let object = UIApplication.shared.delegate
        return object as! AppDelegate
    }
}
