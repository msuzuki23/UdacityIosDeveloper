//
//  Location.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/22/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation

class Location{
    // MARK: - Variables
    //var firstName: String?
    //var lastName: String?
    var addressString: String?
    var latitude: Float?
    var longitude: Float?
    // MARK: - Initialize Variables
    init(addressString: String, latitude: Float, longitude: Float) {//, firstName: String, lastName: String) {
        self.addressString = addressString
        self.latitude = latitude
        self.longitude = longitude
        //self.firstName = firstName
        //self.lastName = lastName
    }
}
