////
////  Map.swift
////  OnTheMap_Draft_5
////
////  Created by msuzuki on 3/17/20.
////  Copyright © 2020 msuzuki. All rights reserved.
////
//
//import Foundation
//
//class Map {
//    
//    static func getAllStudents(url: URL, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
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
//            let parsedData: [String: AnyObject]!
//            
//            do {
//                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
//            } catch {
//                // May Need Some Catch Error Here
//                return
//            }
//            if let result = parsedData["results"] as? [[String: AnyObject]] {
//                completionHandler(result as AnyObject, nil)
//            }
//            
//            
//        }
//        task.resume()
//    }
//}
