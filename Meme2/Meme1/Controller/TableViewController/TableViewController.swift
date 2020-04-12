//
//  TableViewController.swift
//  Meme2
//
//  Created by msuzuki on 3/7/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    var memes: [Meme] = []
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        memes = memeInitializer()
    }
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = memeInitializer()
        tableView.reloadData()  // Reload TableView after meme is added to Array in AppDelegate
    }
    // MARK: - Functions related to UITableViewDataSource, TableView Initializers/Display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseIdentifier")
        cell?.textLabel?.text = memes[indexPath.row].topText
        cell?.imageView?.image = memes[indexPath.row].memedImage
        cell?.separatorInset = .zero
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeShowVC: MemeShowViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeShowViewController") as! MemeShowViewController
        memeShowVC.image = memes[indexPath.row].memedImage
        self.navigationController?.pushViewController(memeShowVC, animated: true)
    }
}
