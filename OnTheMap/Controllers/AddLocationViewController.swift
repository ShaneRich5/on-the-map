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
    @IBOutlet weak var mediaUrlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findLocationButton.isEnabled = false
        locationTextField.delegate = self
        mediaUrlTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AddLocationViewController.segueIdentifier {
            let addPinViewController = segue.destination as! AddPinViewController
            addPinViewController.mediaUrl = mediaUrlTextField.text
            addPinViewController.location = locationTextField.text
        }
    }
    
    func shouldEnableButton() {
        if let location = locationTextField.text, let mediaUrl = mediaUrlTextField.text {
            findLocationButton.isEnabled = !location.isEmpty && !mediaUrl.isEmpty
        } else {
            findLocationButton.isEnabled = false
        }
    }
}

extension AddLocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        shouldEnableButton()
        return true
    }
}
