//
//  Map.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/23/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation

class Map {
    // MARK: - Variables
    var urlString: String = K.Map.URL
    //let accountKey = UserDefaults.standard.object(forKey: "accountKey")
    var locationObjectId = UserDefaults.standard.object(forKey: "locationObjectId")
    var request: URLRequest?
    // MARK: - function method
    func method (method: String, mapString: String?, latitude: Float?, longitude: Float?, mediaURL: String?, completionHandler: @escaping (_ result: AnyObject?, _ error: String?) -> Void) {
        // Set URL
        setURL(method: method)
        // Set Request
        setRequest(method, mapString: mapString, latitude: latitude, longitude: longitude, mediaURL: mediaURL)
        // Execute Task
        callTask() { result, error in
            DispatchQueue.main.async {
                if result != nil {
                    if method == "getOneLocation" || method == "getAllLocations" {
                        DispatchQueue.main.async {
                            self.parseData(method: method, data: result) { result, error in
                                if result != nil {
                                    completionHandler(result, nil)
                                    return
                                } else {
                                    completionHandler(nil, error)
                                    return
                                }
                            }
                        }
                    } else {
                    completionHandler(result!, nil)
                    }
                }
            }
        }
    }
}
