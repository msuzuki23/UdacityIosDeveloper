////
////  MapUpdateLocation.swift
////  OnTheMap_Draft_5
////
////  Created by msuzuki on 3/17/20.
////  Copyright © 2020 msuzuki. All rights reserved.
////
//
//import Foundation
//
//extension Map {
//    
//    static func updateLocation (url: URL, mapString: String, latitude: Float, longitude: Float, mediaURL: String, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
//        // Create Request
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        //request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        //request.httpBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".data(using: .utf8)
//        request.httpBody = "{\"uniqueKey\": \"3\", \"firstName\": \"Markus\", \"lastName\": \"Suzuki\", \"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\", \"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
//        // Create task
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            // Completion Handler, Error Creator
//            func sendError (_ error: String) {
//                //print(error)
//                let userInfo = [NSLocalizedDescriptionKey: error]
//                completionHandler (nil, NSError(domain: "updateLocation", code: 1, userInfo: userInfo))
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
//            // MUST RE_CHECK ERROR MESSAGE
//            print(String(data: data!, encoding: .utf8)!)
//            completionHandler(data as AnyObject, nil)
//            
//
//        }
//        task.resume()
//    }
//    
//    
//    
//    
//}
//
//
