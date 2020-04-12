//
//  AddLinkViewController.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/22/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import MapKit

class AddLinkViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    
    var location: Location!
    
    var annotations = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self  // mapVoew delegate
        
        let latitude = location!.latitude!
        let longitude = location!.longitude!
            
        // Create CLLocationCoordinates2D instance
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        // Set the Coordinates for Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
            
        self.annotations.append(annotation) // Append the Annonation into th Array
        // Add Annocation to napView
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotations)
        }
    }
    // MARK: - IBAction: newLocationButtonPressed
    @IBAction func newLocationButtonPressed(_ sender: UIButton) {
        // Variables
        let latitude = location!.latitude!
        let longitude = location!.longitude!
        let mapString = location!.addressString!
        let mediaURL = linkTextField!.text!
        let method : String
        let locationObjectId = UserDefaults.standard.object(forKey: "locationObjectId")
        // Check for Empty Location Field
        if linkTextField.text!.isEmpty {
            // Pop Window Error
            Common.displayError(viewController: self, title: "Link", message: "Link Cannot Be Empty.")  // From Common Class
            return
        }
        // Set-up Method: updateLocation for PUT, addLocation for POST
        if let locationObjectId = locationObjectId {
            method = "updateLocation"
        } else {
            method = "addLocation"
        }
        // Call Method updateLocation for PUT, addLocation for POST
        Map().method(method: method, mapString: mapString, latitude: latitude, longitude: longitude, mediaURL: mediaURL) { (data, error) in
            DispatchQueue.main.async {
                if (data != nil) {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    let currentViewController = self
                    self.moveToMap(curVC: currentViewController, viewcontrollers: viewControllers,title: "Success!", message: "Location Posted Successfully!")
                } else {
                    Common.displayError(viewController: self, title: "Add Location", message: "Could Not Add Your Location at this time. Try again later.")  // From Common Class
                }
            }
        }
    }
// MARK: - mapView Functions
    // mapView Delegate
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
    
    // mapView respond to Taps
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    // MARK: - Move to Map Window function
    func moveToMap(curVC: UIViewController, viewcontrollers: [UIViewController],title: String, message: String) {
        // Create Alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Create Action
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in curVC.navigationController!.popToViewController(viewcontrollers[viewcontrollers.count - 3], animated: true) }))
        // Show Alert
        self.present(alert, animated: true, completion: nil)
    }
}
