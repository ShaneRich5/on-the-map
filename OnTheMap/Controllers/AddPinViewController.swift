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
        print("annotation: \(annotation)")
    }
    
    @IBAction func saveStudentLocation(_ sender: Any) {
        
    }
    
    func displayLocation(annotation: MKPointAnnotation) {
        mapView.addAnnotation(annotation)
        print("annotation: \(annotation)")
    }
}
