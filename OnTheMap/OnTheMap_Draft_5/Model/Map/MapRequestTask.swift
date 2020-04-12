//
//  MapRequestTask.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/24/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation

extension Map {
    // MARK: - Set URL
    func setURL(method: String) {
        if method == "getOneLocation" {
            //URL = URL + "?uniqueKey=\(accountKey)"
            urlString += "?\(K.Map.UniqueKey)"  // Fixed uniqueKey used as accountKey changes randomly
            return
        } else if (method == "updateLocation") {
            if let locationObjectId = locationObjectId {
                urlString += "/\(locationObjectId)"
            }
            return
        } else if (method == "getAllLocations") {
            urlString += "?limit=50"  // Fixed uniqueKey used as accountKey changes randomly
            return
        }
    }
    // MARK: - Set Request
    func setRequest(_ method: String, mapString: String?, latitude: Float?, longitude: Float?, mediaURL: String?) {
        guard let url = URL(string: urlString) else {
            return
        }
        request = URLRequest(url: url)
        if method == "updateLocation" || method == "addLocation" {
            request?.httpMethod = method == "updateLocation" ? K.Map.UpdateLocation.Method : K.Map.AddLocation.Method
            request?.addValue(K.Map.UpdateLocation.Application, forHTTPHeaderField: K.Map.UpdateLocation.HttpHeader)
            request?.httpBody = "{\"uniqueKey\": \"\(K.Map.UniqueKey)\", \"firstName\": \"Markus\", \"lastName\": \"Suzuki\", \"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(mediaURL!)\", \"latitude\": \(latitude!), \"longitude\": \(longitude!)}".data(using: .utf8)
        }
    }
    // MARK: - Execute Task
    func callTask(completionHandler: @escaping(_ result: AnyObject?, _ error: String?) -> Void) {
        let task = URLSession.shared.dataTask(with: request!) { data, response, error in
            // GUARD: Check for Error
            guard (error == nil) else {
                completionHandler(nil, "Request Error: \(String(describing: error))")
                return
            }
            // GUARD: Successful 2xx Response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil, "Request returned Status Code Other than 2xx!")
                return
            }
            // GUARD: Any Data Returned?
            guard data != nil else {
                completionHandler(nil, "Request returned NO Data!")
                return
            }
            completionHandler(data as AnyObject, nil)
        }
        task.resume()
    }
}
