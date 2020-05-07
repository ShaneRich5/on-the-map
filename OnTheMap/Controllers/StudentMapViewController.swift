//
//  StudentMapViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/25/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit
import MapKit


class StudentMapViewController: UIViewController, Refreshable {
    static var reuseMapId = "studentPin"

    @IBOutlet weak var mapView: MKMapView!
    
    func refresh(students: [Student]) {
        if let currentAnnotations = mapView?.annotations {
            mapView.removeAnnotations(currentAnnotations)
        }
        
        let annotations = students.map { student in loadAnnotation(student) }

        mapView.addAnnotations(annotations)
    }
    
    func loadAnnotation(_ student: Student) -> MKPointAnnotation {
        let latitude = CLLocationDegrees(student.latitude)
        let longitude = CLLocationDegrees(student.longitude)
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        annotation.title = "\(student.firstName!) \(student.lastName!)"
        annotation.subtitle = student.mediaURL
        
        return annotation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
}

extension StudentMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: StudentMapViewController.reuseMapId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: StudentMapViewController.reuseMapId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            guard let linkText = view.annotation?.subtitle!, linkText != "" else {
                return
            }
            
            guard let url = URL(string: linkText), UIApplication.shared.canOpenURL(url) else {
                displayDefaultAlert(title: "Unable to open link", message: "The link value for this pin is invalid")
                return
            }
            
            UIApplication.shared.open(url)
        }
    }
}
