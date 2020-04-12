//
//  Miscellaneous.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/16/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation



// Udacity Class

   // LOG-IN PRESSED
    // Call Udacity Login
    // (success, errorString)
    
    UdacityClient.sharedInstance().loginUser(usernameLogin: UsernameTextField.text ?? "", passwordLogin: PasswordTextField.text ?? "") { (success, errorString) in
        DispatchQueue.main.async {
            if (success != nil) {
                self.completeLogin()
            } else {
                //error added from displayError function
                self.displayError("")
            }
        }
    }




// Call to CompletionHandler is (result, error)
func loginUser (usernameLogin: String, passwordLogin: String, completionHandlerForPost: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
    
    /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST)
     Note: removed paramaters as per project reviewer due to not being in use anywhere.*/
    
    let parameters = [UdacityConstants.Constants.PublicUserURL]
    let parameterKeys = [UdacityConstants.ParameterKeys.username + UdacityConstants.ParameterKeys.password]
    let httpBody: String = "{\"udacity\": {\"username\": \"username\", \"password\": \"password\"}}"
    
    /* 2. Make the request */
    let _ = taskForPostMethod(usernameLogin, url: URL(string: "https://onthemap-api.udacity.com/v1/session")!, username: usernameLogin, password: passwordLogin) { (results, error) in

        
        /* 3. Send the desired value(s) to completion handler */
        if let error = error {
            completionHandlerForPost(nil, error)
        }
        else {
            completionHandlerForPost(results, nil)
        }
    }
}



func taskForPostMethod(_ method: String, url: URL, username: String, password: String, completionHandlerForPost: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
    
    //Parameters
    let url = URL(string:UdacityConstants.Constants.PublicUserURL)
    
    //URL Request
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
    
    //Pass Body to the Request
    /*do {
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
    }*/
    
    
    //create task
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForPost(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
        }
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            sendError("There was an error with your request: \(error!)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            sendError("Your request returned a status code other than 2xx!")
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard data != nil else {
            sendError("No data was returned by the request!")
            return
        }
        
        
        //calling completion handler
        
        let newData = data?.subdata(in: 5..<data!.count)
        if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
            let dict = json as? [String:Any],
            let sessionDict = dict["session"] as? [String: Any],
            let accountDict = dict["account"] as? [String: Any]  {
            
            let key = accountDict["key"] as? String // This is used in getUserInfo(completion:)
            let sessionId = sessionDict["id"] as? String
            print(key ?? "Empty Key")
            print(sessionId ?? "Emty session id")
            completionHandlerForPost(key as AnyObject, nil)
            
        } else { //Err in parsing data
            let errString = "Couldn't parse response"
            let error = [NSLocalizedDescriptionKey : errString]
            completionHandlerForPost(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: error))
        }
    
    }
    task.resume()
}
