//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/25/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit
import MapKit

class AddPinViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var location: String!
    var mediaUrl: String!
    var annotation: MKPointAnnotation!
    var studentLocation: StudentLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // could parse annotation from student location
        mapView.addAnnotation(annotation)
        showLoadingState(isLoading: false)
    }
    
    func buildRequestBody() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(studentLocation)
    }
    
    func showLoadingState(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        finishButton.isEnabled = !isLoading
    }
    
    func buildUrl() -> String {
        let url = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        if let objectId = self.studentLocation.objectId {
            return "\(url)/\(objectId)"
        }
        
        return url
     }
    
    @IBAction func saveStudentLocation(_ sender: Any) {
        guard let url = URL(string: buildUrl()), let requestBody = buildRequestBody() else {
            self.displayDefaultAlert(title: "Error!", message: "Unable to save your location at this time.")
            return
        }
        
        let request = buildRequest(url: url, data: requestBody)
        
        print(request.httpMethod)
        
        showLoadingState(isLoading: true)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.displayDefaultAlert(title: "Save Failed!", message: error?.localizedDescription ?? "Error unclear")
                    self.showLoadingState(isLoading: false)
                }
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            DispatchQueue.main.async {
                defer {
                    self.showLoadingState(isLoading: false)
                }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        self.displayDefaultAlert(title: "Failed Save Location", message: "Unexpected respnse from server")
                        return
                    }
                    
                    if let objectId = json["objectId"] as? String {
                        self.cacheStudentLocation(objectId: objectId)
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    self.displayDefaultAlert(title: "Failed Save Location", message: "Please try again")
                }
            }
        }
        task.resume()
    }
    
    func cacheStudentLocation(objectId: String) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        studentLocation.objectId = objectId
        appDelegate.studentLocation = studentLocation
    }
    
    func buildRequest(url: URL, data: Data) -> URLRequest {
        var request = URLRequest(url: url)
        
        if self.studentLocation.objectId != nil {
            request.httpMethod = "PUT"
        } else {
            request.httpMethod = "POST"
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        return request
    }
}
