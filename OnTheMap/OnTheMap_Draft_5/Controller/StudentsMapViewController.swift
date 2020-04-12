//
//  StudentsMapViewController.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/22/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import MapKit

class StudentsMapViewController: UIViewController, MKMapViewDelegate {
    // MARK: - Variables
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    
    // MARK: - viewDidLoad / viewDidAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleNavButton()
        getAllLocations()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        annotations = []
        getAllLocations()
    }
    // MARK: - Toogle Nav Buttons
    func toggleNavButton() {
//        self.navigationController!.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
//        self.navigationController!.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.systemBlue
    }
    // MARK: - MapView Implementation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    // MARK: - MapView Pin Tap Implementation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let open = view.annotation?.subtitle! {
                app.open(URL(string: open)!) { success in
                    if !success {
                        Common.displayError(viewController: self, title: "URL Connection Failed", message: "Invalid URL.")
                    }
                }
            }
        }
    }
// MARK: - Function gellAllLocations
    func getAllLocations() {
        mapView.delegate = self
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        Map().method(method: "getAllLocations", mapString: nil, latitude: nil, longitude: nil, mediaURL: nil) { (locations, error) in
            DispatchQueue.main.async {
                if (locations != nil) {
                    _ = locations as! [[String : AnyObject]]
                    for location in locations as! [[String : AnyObject]] {
                        let latitude = CLLocationDegrees(truncating: location["latitude"]! as! NSNumber)
                        let longitude = CLLocationDegrees(truncating: location["longitude"]! as! NSNumber)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        annotation.title = ("\(location["firstName"]! as! String) \(location["lastName"]! as! String)")
                        annotation.subtitle = location["mediaURL"]! as! String
                        self.annotations.append(annotation)
                    }
                    DispatchQueue.main.async {
                        self.mapView.addAnnotations(self.annotations)
                    }
                } else {
                    //print("Error: \(error!)")
                    Common.displayError(viewController: self, title: "Display Locations", message: "Could NOT Display Locations at this time. Try again later.")  // From Common Class
                }
            }
        }
    }
}
