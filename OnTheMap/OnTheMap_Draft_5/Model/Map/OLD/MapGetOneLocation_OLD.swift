////
////  MapGetOneLocation.swift
////  OnTheMap_Draft_5
////
////  Created by msuzuki on 3/17/20.
////  Copyright © 2020 msuzuki. All rights reserved.
////
//
//import Foundation
//
//// This can be combined with getAllLocations
//extension Map {
//    static func getOneLocation(url: URL, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
//
//
//        // Request
//        var request = URLRequest(url: url)
//
//        // Task
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//            func sendError(_ error: String) {
//                print(error)
//                let userInfo = [NSLocalizedDescriptionKey: error]
//                completionHandler(nil, NSError(domain: "Map.getAllStudents", code: 1, userInfo: userInfo))
//            }
//            // GUARD: Check for Error
//            guard (error == nil) else {
//                sendError("Request Error: \(error!)")
//                return
//            }
//            // GUARD: Successful 2xx Response?
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                sendError("Request returned Status Code Other than 2xx!")
//                return
//            }
//            // GUARD: Any Data Returned?
//            guard data != nil else {
//                sendError("Request returned NO Data!")
//                return
//            }
//
//            // Parse Data Result
//            // PLACE THIS IN A INDIVIDUAL FUNCTION
//            let parsedData: [String: AnyObject]!
//
//            do {
////                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
//            } catch {
//                // May Need Some Catch Error Here
//                return
//            }
//            if let result = parsedData["results"] as? [[String: AnyObject]] {
//                //print(result)
////                print("Object ID: \(result[0]["objectId"]!)")
//                if let locationObjectId = result[0]["objectId"] {
//                    print(locationObjectId)
//                    UserDefaults.standard.set(locationObjectId, forKey: "locationObjectId")
//                }
//
//
//
////                UserDefaults.standard.set(accountKey!, forKey: "accountKey")
//                completionHandler(result as AnyObject, nil)
//            } else {
//                sendError("User Results as null")
//            }
//        }
//
//        // Return ObjectID
//
//        task.resume()
//    }
//
//
//
//
//}
//
