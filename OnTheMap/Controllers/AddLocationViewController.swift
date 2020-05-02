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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findLocationButton.isEnabled = false
        locationTextField.delegate = self
        mediaUrlTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationTextField.text = "Kingston, Jamaica" // TODO: set to empty text
        mediaUrlTextField.text = "http://google.com" // TODO: set to empty text
    }
    
    func shouldEnableButton() {
        if let location = locationTextField.text, let mediaUrl = mediaUrlTextField.text {
            findLocationButton.isEnabled = !location.isEmpty && !mediaUrl.isEmpty
        } else {
            findLocationButton.isEnabled = false
        }
    }
    
    @IBAction func submitLocation(_ sender: Any) {
        guard let location = locationTextField.text, let mediaUrl = mediaUrlTextField.text else {
            self.displayDefaultAlert(title: "Missing Info", message: "Please enter a location and url.")
            return
        }
        
        guard let url = URL(string: mediaUrl), UIApplication.shared.canOpenURL(url) else {
            self.displayDefaultAlert(title: "Invalid URL", message: "Please enter a valid url value.")
            return
        }
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = location
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: { response, error in
            guard let placemark = response?.mapItems.first?.placemark, error == nil else {
                self.displayDefaultAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.title
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddPinViewController") as! AddPinViewController
            
            controller.annotation = annotation
            controller.location = location
            controller.mediaUrl = mediaUrl
            controller.modalPresentationStyle = .fullScreen
            
            self.navigationController!.pushViewController(controller, animated: true)
            
        })
    }
}

extension AddLocationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        shouldEnableButton()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        shouldEnableButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        shouldEnableButton()
        return true
    }
}
