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
    
    func postStudentLocation() {
        
    }
    
    func updateStudentLocation() {
        
    }
    
    @IBAction func saveStudentLocation(_ sender: Any) {
        showLoadingState(isLoading: true)
        
        if let objectId = self.studentLocation.objectId {
            UdacityClient.updateStudentLocation(objectId: objectId, studentLocation: self.studentLocation, completion: { success, error in
                
                self.showLoadingState(isLoading: false)
                
                if success && error == nil {
                    self.displayDefaultAlert(title: "Error!", message: "Unable to save your location at this time.")
                } else {
                    self.goToTabView()
                }
            })
        } else {
            UdacityClient.saveStudentLocation(studentLocation: studentLocation, completion: { objectId, error in
                
                if let objectId = objectId, error == nil {
                    self.cacheStudentLocation(objectId: objectId)
                    self.goToTabView()
                } else {
                    self.displayDefaultAlert(title: "Error!", message: "Unable to save your location at this time.")
                }
            })
        }
    }
    
    func goToTabView() {
        for controller in navigationController!.viewControllers as Array {
            if controller.isKind(of: StudentTabViewController.self) {
                navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    func cacheStudentLocation(objectId: String) {
        studentLocation.objectId = objectId
        
        let appDelegate = self.getApplicationDelegate()
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
