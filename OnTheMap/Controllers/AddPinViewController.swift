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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func saveStudentLocation(_ sender: Any) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
}
