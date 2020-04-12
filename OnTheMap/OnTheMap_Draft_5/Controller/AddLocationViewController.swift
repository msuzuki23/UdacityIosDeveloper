//
//  AddLocationViewController.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/22/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addressStringTextField: UITextField!
    // MARK - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    // MARK: - getCoordinatesButtonPressed
    @IBAction func getCoordinatesButtonPressed(_ sender: UIButton) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        // Check for Empty Location Field
        if addressStringTextField.text!.isEmpty {
            // Pop Window Error
            Common.displayError(viewController: self, title: "Location", message: "Location Cannot Be Empty.")  // From Common Class
            return
        }
        let addressString = addressStringTextField.text!
        getCoordinate(addressString: addressString) { (coordinates, error) in
            //DispatchQueue.main.async {
                if (coordinates != nil) {
                    let location = Location(addressString: addressString, latitude: Float(coordinates!.latitude), longitude: Float(coordinates!.longitude))
                    self.performSegue(withIdentifier: "AddLinkSegue", sender: location)
                } else {
                    // From Common Class - Pop Window with Error
                    Common.displayError(viewController: self, title: "Cannot Get Location", message: "Error: \(error!)")
                }
            //}
        }
    }
    // MARK: - Overwrite Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddLinkSegue" {
            let destinationVC = segue.destination as! AddLinkViewController
            destinationVC.location = (sender as! Location)
        }
    }
    // MARK: - Get Coordinate Function (Corelocation Package)
    func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D?, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(nil, error as NSError?)
        }
    }
}
