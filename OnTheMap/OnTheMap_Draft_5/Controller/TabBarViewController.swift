//
//  TabBarViewController.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/21/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    // MARK: - viewDidLoard
    override func viewDidLoad() {
        super.viewDidLoad()
                let backButton = UIBarButtonItem()
                backButton.title = "Logout"
                self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        if parent == nil {
            Udacity.destroySession { result, error in
                guard error == nil else {
                    Common.displayError(viewController: self, title: " Error in Logging Out", message: "Error in Logging Out! Please try it again!")
                    return
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
        print("Hi from TabBarController - viewDidAppear")
        self.selectedIndex = 0
    }
    // MARK: - addLocationButtonPressed
    @IBAction func addLocationButtonPressed(_ sender: UIBarButtonItem) {
        Map().method(method: "getOneLocation", mapString: nil, latitude: nil, longitude: nil, mediaURL: nil) { (location, error) in
            DispatchQueue.main.async {
                if (location != nil) {
                    self.locationExists(title: "Location Already Exists", message: "Would you like to Overwrite it?")
                } else {
                    self.performSegue(withIdentifier: "LocationExistsSegue", sender: self)
                }
            }
        }
    }
    // MARK: - Alert Window
    // Reference: https://stackoverflow.com/questions/28591514/uialertcontroller-segue-to-different-page-swift
    // Reference: https://learnappmaking.com/uialertcontroller-alerts-swift-how-to/
    func locationExists(title: String, message: String) {
        // Create Alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Add Action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in self.performSegue(withIdentifier: "LocationExistsSegue", sender: self) }))
        // Show Alert
        self.present(alert, animated: true, completion: nil)
    }
}
