//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/22/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit

class StudentTabViewController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let mapIcon = UIImage(named: "icon_pin")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: mapIcon, style: .plain, target: self, action: #selector(addPin))
        
        let refreshIcon = UIImage(named: "icon_refresh")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: refreshIcon, style: .plain, target: self, action: #selector(refresh))
        
        print("StudentTabViewController:viewWillAppear")
        self.loadStudents()
    }
    
    func loadStudents() {
        print("StudentTabViewController:loadStudents")
        let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Request Error \(error)")
                return
            }
            
            print("task running...")

            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(StudentListResponse.self, from: data)
                    let object = UIApplication.shared.delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.students = result.results
                    
//                    print(result.results.count)
                    if let tabControllers = self.viewControllers as? [Refreshable] {
                        for controller in tabControllers {
                            print("result.results \(result.results[0])")
                            controller.refresh(students: result.results)
                        }
                    }
                } catch {
                    print("error occured: \(error)")
                }
                
                print("task ended...")
            }
        }
        
        task.resume()
    }
    
    @objc func refresh() {
        print("refreshing...")
        loadStudents()
    }
    
    
    @objc func addPin() {
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
    }
}
