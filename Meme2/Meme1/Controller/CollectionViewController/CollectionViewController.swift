//
//  CollectionViewController.swift
//  Meme2
//
//  Created by msuzuki on 3/7/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

// References on UICollectionView
// https://knowledge.udacity.com/questions/78981
// https://stackoverflow.com/questions/32593117/uicollectionviewcell-content-wrong-size-on-first-load

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Variables
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [Meme] = []
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        memes = memeInitializer()
        flowLayoutSetup()
    }
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = memeInitializer()
        collectionView.reloadData()
    }
    // MARK: - Functions related to Initialize UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCollectionCell
        cell.memeImageView.image = memes[indexPath.row].memedImage
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeShowVC: MemeShowViewController = storyboard?.instantiateViewController(withIdentifier: "MemeShowViewController") as! MemeShowViewController
        memeShowVC.image = memes[indexPath.row].memedImage
        navigationController?.pushViewController(memeShowVC, animated: true)
    }
}

