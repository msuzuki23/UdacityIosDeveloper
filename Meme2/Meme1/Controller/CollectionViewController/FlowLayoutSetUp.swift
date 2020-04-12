//
//  FlowLayoutSetUp.swift
//  Meme2
//
//  Created by msuzuki on 3/9/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

extension CollectionViewController {
    // MARK: - Set-up for flowLayout
    func flowLayoutSetup() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
