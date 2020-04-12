//
//  MapParseJSON.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/24/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation

extension Map {
    // MARK: - Parse JSON
    func parseData(method: String, data: AnyObject?, completionHandler: @escaping(_ result: AnyObject?, _ error: String?) -> Void) {
        let parsedData: [String: AnyObject]!
        do {
            parsedData = try JSONSerialization.jsonObject(with: data as! Data, options: .allowFragments) as? [String: AnyObject]
        } catch {
            completionHandler(nil, "Could NOT Deserialize JSON!")
            return
        }
        if let result = parsedData["results"] as? [[String: AnyObject]] {
            // If Location Exists, set-up objectID for PUT Method
            if method == "getOneLocation" {
                if let locationObjectId = result[0]["objectId"] {
                    UserDefaults.standard.set(locationObjectId, forKey: "locationObjectId")
                    completionHandler(result as! AnyObject, nil)
                    return
                } else {
                    completionHandler(nil, "User Results as Null")
                }
            }
                completionHandler(result as! AnyObject, nil)
        } else {
            completionHandler(nil, "Could Not Parse JSON")
        }
    }
}
