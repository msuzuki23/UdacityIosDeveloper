//
//  Common.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/20/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation
import UIKit

class Common {
    static func displayError(viewController: UIViewController, title: String, message: String) {
        // Create Alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Add Action
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Show Alert
        viewController.present(alert, animated: true, completion: nil)
    }
}
