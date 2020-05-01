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
            print("currentAnnotations count: \(currentAnnotations.count)")
            mapView.removeAnnotations(currentAnnotations)
        }
        
        print("map student: \(students.count)")
        let annotations = students.map { student in loadAnnotation(student) }
        print("map annotation: \(annotations.count)")
                
        mapView.addAnnotations(annotations)
        print("StudentMapViewController:refresh")
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
        print("StudentMapViewController:viewDidLoad")
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
//        print(pinView)
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                let url = URL(string: toOpen)!
                UIApplication.shared.open(url)
            }
        }
    }
}
