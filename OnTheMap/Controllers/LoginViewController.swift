//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/21/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController {
    static var segueIdentifier = "goToMap"

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userId: String?
    var sessionId: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func openSignUpLink(_ sender: Any) {
        let url = URL(string: UdacityClient.signUpUrl)!
        UIApplication.shared.open(url)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func showRequestInProgress(_ isInProgress: Bool) {
        if isInProgress {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        emailTextField.isEnabled = !isInProgress
        passwordTextField.isEnabled = !isInProgress
        loginButton.isEnabled = !isInProgress
        signUpButton.isEnabled = !isInProgress
    }
    
    @IBAction func loginUsingCredentials(_ sender: Any) {
        guard let email = emailTextField?.text, let password = passwordTextField?.text else {
            displayDefaultAlert(title: "Validation", message: "Both the email and password fields are required")
            return
        }
        
        showRequestInProgress(true)
        
        UdacityClient.login(email: email, password: password, completion: handleLoginResponse(sessionId:userId:error:))
    }
    
    func handleLoginResponse(sessionId: String?, userId: String?, error: Error?) {
        guard let sessionId = sessionId, let userId = userId, error == nil else {
            self.showNetworkError()
            return
        }
        
        self.sessionId = sessionId
        self.userId = userId
        
        UdacityClient.getUser(userId: userId, completion: handleUserResponse(user:error:))
    }
    
    func handleUserResponse(user: User?, error: Error?) {
        guard let user = user, error == nil else {
            self.showNetworkError()
            return
        }
        
        self.cacheUserDetails(user: user)
        self.showRequestInProgress(false)
        self.performSegue(withIdentifier: LoginViewController.segueIdentifier, sender: nil)
    }
    
    func showNetworkError() {
        self.displayDefaultAlert(title: "Login Failed", message: "An error occured while connecting to the server. Please try again.")
        self.showRequestInProgress(false)
    }
    
    func cacheUserDetails(user: User) {
        let appDelegate = self.getApplicationDelegate()
        return appDelegate.user = user
    }
}
