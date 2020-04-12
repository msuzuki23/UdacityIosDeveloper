//
//  MemeFunctions.swift
//  Meme1
//
//  Created by msuzuki on 2/29/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

extension MemeViewController {
    // MARK: - save function
    func save() {
        let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: generateMemedImage())
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    // MARK: - generateMemedImage
    func generateMemedImage() -> UIImage {
        // HideNavbar and Toolbar
        hiTopAndBottomBars(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // Show Navbar and Toolbar
        hiTopAndBottomBars(false)
        return memedImage
    }
    // MARK: - Show/Hide Navbar, Toolbar
    func hiTopAndBottomBars(_ status: Bool) {
        navigationbarView.isHidden = status
        toolbarView.isHidden = status
    }
}
