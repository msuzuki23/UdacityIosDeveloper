//
//  MemeShowViewController.swift
//  Meme2
//
//  Created by msuzuki on 3/11/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

class MemeShowViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet weak var memeShowImageView: UIImageView!
    var image: UIImage!
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        memeShowImageView.image = image
    }
}
