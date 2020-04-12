//
//  K.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/23/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation

struct K {
    // MARK: - Login API
    struct Udacity {
        static let URL: String = "https://onthemap-api.udacity.com/v1/session"
        static let SignUp: String = "https://auth.udacity.com/sign-up"
    }
    // MARK: - Map API
    struct Map {
        // Baseline URL
        static let URL: String = "https://onthemap-api.udacity.com/v1/StudentLocation"
        // UniqueKey
        static let UniqueKey = 1234 // Fixed uniqueKey used as accountKey changes randomly
        // PUT Config
        struct UpdateLocation {
            static let Method = "PUT"
            static let Application = "application/json"
            static let HttpHeader = "Content-Type"
        }
        // POST Config
        struct AddLocation {
            static let Method = "POST"
            static let Application = "application/json"
            static let HttpHeader = "Content-Type"
        }
    }
}
