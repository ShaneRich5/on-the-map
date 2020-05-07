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
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        mapView.setRegion(region, animated: true)
        showLoadingState(isLoading: false)
    }
    
    func showLoadingState(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        finishButton.isEnabled = !isLoading
    }
    
    func postStudentLocation() {
        UdacityClient.saveStudentLocation(studentLocation: studentLocation, completion: { objectId, error in
            
            if let objectId = objectId, error == nil {
                self.cacheStudentLocation(objectId: objectId)
                self.goToTabView()
            } else {
                self.displayDefaultAlert(title: "Error!", message: "Unable to save your location at this time.")
            }
            
            self.showLoadingState(isLoading: false)
        })
    }
    
    func updateStudentLocation(objectId: String) {
        UdacityClient.updateStudentLocation(objectId: objectId, studentLocation: self.studentLocation, completion: { success, error in
            
            if success && error == nil {
                self.displayDefaultAlert(title: "Error!", message: "Unable to save your location at this time.")
            } else {
                self.goToTabView()
            }
            
            self.showLoadingState(isLoading: false)
        })
    }
    
    @IBAction func saveStudentLocation(_ sender: Any) {
        showLoadingState(isLoading: true)
        
        if let objectId = self.studentLocation.objectId {
            updateStudentLocation(objectId: objectId)
        } else {
            postStudentLocation()
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
}
