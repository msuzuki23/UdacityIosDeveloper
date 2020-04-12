//
//  AddLocationViewController.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/22/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import CoreLocation

class GetLocationViewController: UITabBarController {

    
    
    @IBOutlet weak var addressStringTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func getCoordinatesButtonPressed(_ sender: UIButton) {
        
//        if addressStringTextField.text!.isEmpty {
//            Common.displayError(viewController: self, title: "Location", message: "Location Cannot Be Empty.")
//            return
//        }
//        
//        
//        let addressString = addressStringTextField.text!
//            getCoordinate(addressString: addressString) { (coordinates, error) in
//                DispatchQueue.main.async {
//                    if (coordinates != nil) {
//                        print("Latitude: \(coordinates!.latitude), Longitude: \(coordinates!.longitude)")
//                    } else {
//                        print("Error: \(error!)")
//                    }
//                }
//            }
        
    }
    
    
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
