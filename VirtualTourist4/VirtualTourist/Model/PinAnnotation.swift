//
//  PinAnnotation.swift
//  VirtualTourist
//
//  Created by msuzuki on 5/9/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    let title: String? = nil
    let subtitle: String? = nil
    let coordinate: CLLocationCoordinate2D
    var pin: Pin
    
    init(coordinate: CLLocationCoordinate2D, pin: Pin) {
        self.coordinate = coordinate
        self.pin = pin
        super.init()
    }
}
