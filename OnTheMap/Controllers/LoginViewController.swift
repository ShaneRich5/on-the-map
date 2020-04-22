//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/21/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginUsingCredentials(_ sender: Any) {
        
    }
    
    @IBAction func loginUsingFacebook(_ sender: Any) {
    }
}
