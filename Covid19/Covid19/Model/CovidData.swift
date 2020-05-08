//
//  CovidData.swift
//  Covid19
//
//  Created by msuzuki on 5/6/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation

class CovidData: Decodable {
    let Countries: [Country]
    
    init(Countries: [Country]) {
        self.Countries = Countries
    }
}

class Country: Decodable {
    let Country: String
    let CountryCode: String
    let TotalConfirmed: Int
    let TotalDeaths: Int
    let TotalRecovered: Int
    
    init(Country: String, CountryCode: String, TotalConfirmed: Int, TotalDeaths: Int, TotalRecovered: Int) {
        self.Country = Country
        self.CountryCode = CountryCode
        self.TotalConfirmed = TotalConfirmed
        self.TotalDeaths = TotalDeaths
        self.TotalRecovered = TotalRecovered
        
    }
}
