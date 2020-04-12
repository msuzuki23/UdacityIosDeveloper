//
//  UdestroySession.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 4/11/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation

extension Udacity {
    
    static func destroySession(completionHandler: @escaping (_ result: String?, _ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: K.Udacity.URL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          // GUARD: Check for Error
          guard (error == nil) else {
              completionHandler(nil, "Error in Processing Destroy Session. Error: \(error)")
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
          //let range = Range(5..<data!.count)
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! */
          //print(String(data: newData!, encoding: .utf8)!)
          // Remove accountKey and sessionId for App
          UserDefaults.standard.removeObject(forKey: "accountKey")
          UserDefaults.standard.removeObject(forKey: "sessionId")
          UserDefaults.standard.removeObject(forKey: "locationObjectId")
          UserDefaults.standard.synchronize()
          completionHandler("Successfully Destroyed Session. Message: \(String(data: newData!, encoding: .utf8)!)", nil)
        }
        task.resume()
    }
}
