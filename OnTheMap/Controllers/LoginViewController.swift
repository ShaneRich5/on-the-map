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
        let url = URL(string: "https://auth.udacity.com/sign-up")!
        UIApplication.shared.open(url)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = "shane.richards121@gmail.com"
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
        facebookButton.isEnabled = !isInProgress
    }
    
    func buildRequestForSession(email: String, password: String) -> URLRequest {
        let credentials = UdacityCredentials(udacity: Credentials(username: email, password: password))
        let url = URL(string: "https://onthemap-api.udacity.com/v1/session")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(credentials) // TODO: alert for errors
        
        return request
    }
    
    func buildRequestForUser(_ userId: String) -> URLRequest {
        let endpoint = "https://onthemap-api.udacity.com/v1/users/\(userId)"
        let url = URL(string: endpoint)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    func parseLoginResponseData(_ data: Data) throws -> LoginResponse {
        let range = 5..<data.count
        let data = data.subdata(in: range)

        let decoder = JSONDecoder()
        return try decoder.decode(LoginResponse.self, from: data)
    }
    
    @IBAction func loginUsingCredentials(_ sender: Any) {
//        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MapTabViewController") as! ResultsViewController
        guard let email = emailTextField?.text else {
            print("email is required") // TODO: Alert here
            return
        }
        
        guard let password = passwordTextField?.text else {
            print("password is empty") // TODO: Alert here
            return
        }
        
        showRequestInProgress(true)
        
        let loginTask = login(email, password)
        loginTask.resume()
    }
    
    func parseUserResponseData(_ data: Data) throws -> UserDetailResponse {
        let range = 5..<data.count
        let data = data.subdata(in: range)

        let decoder = JSONDecoder()
        return try decoder.decode(UserDetailResponse.self, from: data)
    }
    
    func cacheUserDetails(user: User) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.user = user
    }
    
    func getUser(_ userId: String) -> URLSessionTask {
//        print("getUser")
        let request = buildRequestForUser(userId)
        return URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Not data received")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let result = try self.parseUserResponseData(data)
//                    print("user response: \(result.userId), \(result.firstName) \(result.lastName)")
                    self.showRequestInProgress(false)
                    
                    let user = result.toUser()
                    self.cacheUserDetails(user: user)
                    
                    self.performSegue(withIdentifier: LoginViewController.segueIdentifier, sender: nil)
//                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MapTabViewController") as! StudentMapViewController
                    
                } catch {
                    self.showRequestInProgress(false)
                    print(error)
                }
            }
        }
    }
    
    func login(_ email: String, _ password: String) -> URLSessionTask {
        let request = buildRequestForSession(email: email, password: password)
        return URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error!)
                self.showRequestInProgress(false)
                return
            }
            
            guard let data = data else {
                print("Not data received")
                self.showRequestInProgress(false)
                return
            }

            DispatchQueue.main.async {
                do {
                    let loginResponse = try self.parseLoginResponseData(data)
                    
                    self.sessionId = loginResponse.session.id!
                    self.userId = loginResponse.account.key!
                    
                    let task = self.getUser(self.userId!)
                    task.resume()
                } catch {
                    self.showRequestInProgress(false)
                    print(error)
                }
            }
        }
    }
    
    @IBAction func loginUsingFacebook(_ sender: Any) {}
    
    func displayAlert(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
