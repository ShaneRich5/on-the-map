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
    
    var location: String!
    var mediaUrl: String!
    var annotation: MKPointAnnotation!
    var studentLocation: StudentLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.addAnnotation(annotation)
    }
    
    func buildRequestBody() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(studentLocation)
    }
    
    @IBAction func saveStudentLocation(_ sender: Any) {
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation"), let requestBody = buildRequestBody() else {
            self.displayDefaultAlert(title: "Error!", message: "Unable to save your location at this time.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.displayDefaultAlert(title: "Save Failed!", message: error?.localizedDescription ?? "Error unclear")
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        task.resume()
    }
}
