//
//  Udacity.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/16/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation

class Udacity {
    // MARK: - Login
    static func login (url: URL, user: String, password: String, completionHandler: @escaping (_ result: AnyObject?, _ error: String?) -> Void) {
        // Create Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        // Create task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check or Internet Connection / Logg-in
            if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
                completionHandler(nil, "No Internet Connection")
                return
            }
            // GUARD: Check for Error
            guard (error == nil) else {
                completionHandler(nil, "Error in Logging In: \(error!)")
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
            // De-Serealize Data
            let returnedData = data?.subdata(in: 5..<data!.count)
            if let json = try? JSONSerialization.jsonObject(with: returnedData!, options: []),
                let dict = json as? [String:Any],
                let sessionDict = dict["session"] as? [String: Any],
                let accountDict = dict["account"] as? [String: Any] {
                let accountKey = accountDict["key"] as? String // This is used in getUserInfo(completion:)
                let sessionId = sessionDict["id"] as? String
                // Set accountKey and sessionId for App
                UserDefaults.standard.set(accountKey!, forKey: "accountKey")
                UserDefaults.standard.set(sessionId!, forKey: "sessionId")
                UserDefaults.standard.removeObject(forKey: "locationObjectId")
                UserDefaults.standard.synchronize()
                completionHandler(dict as AnyObject, nil)
            } else {
                completionHandler(nil, "Error in Parsing JSON")
            }
        }
        task.resume()
    }
}
