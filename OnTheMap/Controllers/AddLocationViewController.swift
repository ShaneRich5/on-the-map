//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/25/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    static var segueIdentifier = "addPin"
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var addPinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPinButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AddLocationViewController.segueIdentifier {
            let addPinViewController = segue.destination as! AddPinViewController
            addPinViewController.mediaUrl = mediaURLTextField.text
            addPinViewController.location = locationTextField.text
        }
    }
}
