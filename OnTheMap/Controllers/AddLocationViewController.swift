//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/25/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    static var segueIdentifier = "addPin"
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaUrlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationTextField.text = "Kingston, Jamaica" // TODO: set to empty text
        mediaUrlTextField.text = "http://google.com" // TODO: set to empty text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading(isLoading: false)
    }
    
    func showLoading(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        locationTextField.isEnabled = !isLoading
        mediaUrlTextField.isEnabled = !isLoading
    }
    
    @IBAction func submitLocation(_ sender: Any) {
        showLoading(isLoading: true)
        
        guard let location = locationTextField.text, let mediaUrl = mediaUrlTextField.text else {
            self.displayDefaultAlert(title: "Missing Info", message: "Please enter a location and url.")
            self.showLoading(isLoading: false)
            return
        }
        
        guard let url = URL(string: mediaUrl), UIApplication.shared.canOpenURL(url) else {
            self.displayDefaultAlert(title: "Invalid URL", message: "Please enter a valid url value.")
            self.showLoading(isLoading: false)
            return
        }
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = location
        
        let search = MKLocalSearch(request: searchRequest)
        
        showLoading(isLoading: true)
        
        search.start(completionHandler: { response, error in
            guard let placemark = response?.mapItems.first?.placemark, error == nil else {
                self.displayDefaultAlert(title: "Error", message: error!.localizedDescription)
                self.showLoading(isLoading: false)
                return
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.title
            
            
            let studentLocation = StudentLocation(uniqueKey: "aaaa", firstName: "Shane", lastName: "Richards", mapString: location, mediaURL: mediaUrl, latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
            
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddPinViewController") as! AddPinViewController
            
            controller.annotation = annotation
            controller.location = location
            controller.mediaUrl = mediaUrl
            controller.studentLocation = studentLocation

            
            controller.modalPresentationStyle = .fullScreen
            
            self.navigationController!.pushViewController(controller, animated: true)
            showLoading(isLoading: false)
        })
    }
}
