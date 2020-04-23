//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/22/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit

class AddPinViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelSubmission(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
