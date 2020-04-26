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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == AddLocationViewController.segueIdentifier {
//            let addPinViewController = segue.destination as! AddPinViewController
//            addPinViewController.mediaUrl = mediaUrlTextField.text
//            addPinViewController.location = locationTextField.text
//            addPinViewController.displayLocation(annotation: annotation!)
//        }
//    }
    
    func shouldEnableButton() {
        if let location = locationTextField.text, let mediaUrl = mediaUrlTextField.text {
            findLocationButton.isEnabled = !location.isEmpty && !mediaUrl.isEmpty
        } else {
            findLocationButton.isEnabled = false
        }
    }
    
    @IBAction func submitLocation(_ sender: Any) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationTextField.text
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            guard let placemarker = response.mapItems.first?.placemark else {
                print("Error: no markers returned")
                return
            }
            
            let annotation = self.createAnnotation(placemarker: placemarker)
            self.navigateToMap(annotation)
        })
    }
    
    func createAnnotation(placemarker: MKPlacemark) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemarker.coordinate
        annotation.title = placemarker.title
        return annotation
    }
    
    func navigateToMap(_ annotation: MKPointAnnotation) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddPinViewController") as! AddPinViewController
        
        controller.annotation = annotation
        controller.location = self.locationTextField.text
        controller.mediaUrl = self.mediaUrlTextField.text
        controller.modalPresentationStyle = .fullScreen
        
        self.navigationController!.pushViewController(controller, animated: true)
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
