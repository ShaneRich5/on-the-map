//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/22/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit

class StudentTabViewController: UITabBarController {
    
    var loadStudentTask: URLSessionTask?

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
        _ = UdacityClient.logout(completion: { success, error in
            if success && error == nil {
                _ = self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.displayNetworkError()
            }
        })
    }
    
    func displayNetworkError() {
        self.displayDefaultAlert(title: "Loading Failed", message: "Unable to load students at this time. Please try again later by clicking the refresh icon.")
    }
    
    func handleStudentResponse(students: [Student]?, error: Error?) {
        guard let students = students, error == nil else {
            self.displayNetworkError()
            return
        }
        
        if let tabControllers = self.viewControllers as? [Refreshable] {
            for controller in tabControllers {
                controller.refresh(students: students)
            }
        }
    }
    
    func loadStudents() {
        loadStudentTask?.cancel()
        loadStudentTask = UdacityClient.loadStudents(completion: handleStudentResponse(students:error:))
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
