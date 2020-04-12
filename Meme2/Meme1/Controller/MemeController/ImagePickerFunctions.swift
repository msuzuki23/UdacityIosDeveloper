//
//  ImagePickerFunctions.swift
//  Meme1
//
//  Created by msuzuki on 2/29/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

extension MemeViewController {
    // MARK: - Open Image Picker either from Phone Camera or Photo Album/Gallery
    func pickImageFromSouce(_ source: String) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source == "Camera" ? .camera : .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    // MARK: - DidFinish Picking Media (Photo)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            toggle(false)
        }
        dismiss(animated: true, completion: nil)
    }
    // MARK: - // DidCancel Picking Media (Photo)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        toggle(true)
        dismiss(animated: true, completion: nil)
    }
}
