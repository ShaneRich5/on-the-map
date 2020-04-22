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
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let credentials = UdacityCredentials(udacity: Credentials(username: email, password: password))
        
        let url = URL(string: "https://onthemap-api.udacity.com/v1/session")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // handle this properly
        request.httpBody = try! JSONEncoder().encode(credentials)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.displayAlert(title: "Request Error", message: "\(error)")
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let range = 5..<data.count
                    let data = data.subdata(in: range)
                    
                    let decoder = JSONDecoder()
                    let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                    let sessionId = loginResponse.session.id
                    
                    self.displayAlert(title: "Login Successful", message: "Session ID: \(sessionId ?? "No ID")")
                } catch { error
                    self.displayAlert(title: "Error", message: "Unable to parse response \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    @IBAction func loginUsingFacebook(_ sender: Any) {
    }
    
    func displayAlert(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
