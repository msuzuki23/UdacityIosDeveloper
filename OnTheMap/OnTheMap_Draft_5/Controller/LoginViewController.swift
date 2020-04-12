//
//  LoginViewController.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/20/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - loginButtonPressed
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // Variables
        let urlUdacity = K.Udacity.URL  // Constant from K Class
        let user = userTextField.text!
        let password = passwordTextField.text!
        // Check for Empty Text Field
        if userTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            // Calls Error Window from Common
            Common.displayError(viewController: self, title: "Login Failed", message: "Username or Password is Empty.")
            return
        }
        // Check URL String
        guard let url = URL(string: urlUdacity) else {
            return
        }
        // Udacity.login - POST Method
        Udacity.login(url: url, user: user, password: password) { jsonPayload, error in
            DispatchQueue.main.async {
                if (jsonPayload != nil) {
                    self.performSegue(withIdentifier: "LoginToTabBar", sender: self)
                } else {
                    if error == "No Internet Connection" {
                        Common.displayError(viewController: self, title: "Login Failed", message: "Not Internet Connection!")
                    } else {
                        Common.displayError(viewController: self, title: "Login Failed", message: "Wrong User or Password.")
                    }
                }
            }
        }
    }
    // MARK: - SignUp Button Pressed - Takes to Udacity Create User/Password
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        let url = URL(string: K.Udacity.SignUp) // Constant from K Class
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}
