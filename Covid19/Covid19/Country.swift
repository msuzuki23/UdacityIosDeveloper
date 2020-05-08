//
//  Country.swift
//  Covid19
//
//  Created by msuzuki on 5/5/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation
import RealmSwift

// Reference:
// https://stackoverflow.com/questions/33390578/inserting-data-with-one-to-one-relationship-realm

class Country: Object {
    @objc dynamic var countryCode: String = ""
    @objc dynamic var countryName: String = ""
    @objc dynamic var lat: Float = 0.0
    @objc dynamic var lon: Float = 0.0
    @objc dynamic var totalConfirmed: Int = 0
    @objc dynamic var totalDeaths: Int = 0
    @objc dynamic var totalRecovered: Int = 0
}
