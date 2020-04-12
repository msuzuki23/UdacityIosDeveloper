//
//  TextFields.swift
//  Meme1
//
//  Created by msuzuki on 3/1/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

extension ViewController {

    func setupTextField(_ textField: UITextField, text: String) {
        let memeTextAttributes:[NSAttributedString.Key:Any] = [
                                                        NSAttributedString.Key.strokeColor: UIColor.black,
                                                        NSAttributedString.Key.foregroundColor: UIColor.white,
                                                        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                                        NSAttributedString.Key.strokeWidth: -4.0
                                                    ]
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
}
