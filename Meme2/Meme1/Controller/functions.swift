//
//  File.swift
//  Meme2
//
//  Created by msuzuki on 3/9/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

// MARK: - Initializer for Meme Array
func memeInitializer() -> [Meme]{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.memes
}

