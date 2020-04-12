//
//  TextAttributes.swift
//  Meme1
//
//  Created by msuzuki on 3/1/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

extension ViewController {
    
    let memeTextAttributes:[String:Any] =
                                [
                                    NSAttributedString.Key.strokeColor.rawValue : UIColor.black,
                                    NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
                                    NSAttributedString.Key.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                    NSAttributedString.Key.strokeWidth.rawValue: -3.0
                                ]
    
}
