//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/22/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit

class StudentTabViewController: UITabBarController {

    func createButtonBarItem(imageName: String, selector: Selector) -> UIBarButtonItem {
        let icon = UIImage(named: imageName)
        return UIBarButtonItem(image: icon, style: .plain, target: self, action: selector)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.navigationItem.rightBarButtonItems = [
            createButtonBarItem(imageName: "icon_pin", selector: #selector(addPin)),
            createButtonBarItem(imageName: "icon_refresh", selector: #selector(refresh))
        ]
        
        self.navigationItem.title = "On The Map"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        self.loadStudents()
    }
    
    @objc func logout() {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error != nil else {
                self.displayNetworkError()
                return
            }
            
            DispatchQueue.main.async {
                let appDelegate = self.getApplicationDelegate()
                appDelegate.studentLocation = nil
                appDelegate.user = nil
                self.dismiss(animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    func displayNetworkError() {
        self.displayDefaultAlert(title: "Loading Failed", message: "Unable to load students at this time. Please try again later by clicking the refresh icon.")
    }
    
    func loadStudents() {
        let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.displayNetworkError()
                }
                return
            }

            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(StudentListResponse.self, from: data)
                    
                    if let tabControllers = self.viewControllers as? [Refreshable] {
                        for controller in tabControllers {
                            controller.refresh(students: result.results)
                        }
                    }
                } catch {
                    self.displayNetworkError()
                }
            }
        }
        
        task.resume()
    }
    
    @objc func refresh() {
        loadStudents()
    }
    
    
    @objc func addPin() {
        let appDelegate = getApplicationDelegate()
        
        if appDelegate.studentLocation != nil {
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { (action) in
                self.performSegue(withIdentifier: "addLocation", sender: nil)
            //            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            //            controller.modalPresentationStyle = .fullScreen
            //            self.present(controller, animated: true)
                    }
                    
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            let message = "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            alert.addAction(overwriteAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "addLocation", sender: nil)
        }
    }
}
