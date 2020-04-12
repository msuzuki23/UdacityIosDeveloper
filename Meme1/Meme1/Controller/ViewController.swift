//
//  ViewController.swift
//  Meme1
//
//  Created by msuzuki on 2/29/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var navigationbarView: UINavigationBar!
    @IBOutlet weak var toolbarView: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButtom: UIBarButtonItem!
    // MARK: - InitialLoader
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        toggle(true)
    }
    // MARK: - Toolbar ImagePicker: Camera/Album
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        pickImageFromSouce(sender.title!)
    }
    // MARK: - Navbar: share/cancel Buttons
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activity, success, items, error) in
            if success{
                self.save()
                self.toggle(true)
                let alertMessage = "Meme was Successfully Shared."
                let alertController = UIAlertController(title: "Meme Shared", message: alertMessage , preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        self.present(activityController, animated: true, completion: nil)
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        toggle(true)
    }
    // MARK: - viewWillAppear / viewWillDisappear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    // MARK: - Initializer: Enable/Disable Navbar, Toolbar, Textfields
    func toggle(_ initial: Bool) {
        setupTextField(topTextField, text: "TOP TEXT")
        setupTextField(bottomTextField, text: "TOP TEXT")
        topTextField.isHidden = initial
        bottomTextField.isHidden = initial
        if initial {imagePickerView.image = nil}
        //cameraButton.isEnabled = initial
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) ? initial : false
        shareButton.isEnabled = !initial
        cancelButton.isEnabled = !initial
    }
}
