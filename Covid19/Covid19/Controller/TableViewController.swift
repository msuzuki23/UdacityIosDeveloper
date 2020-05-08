//
//  TableViewController.swift
//  Covid19
//
//  Created by msuzuki on 5/6/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TableViewController: UpdateCasesViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70.0  // tableView row height to accomodate Favorite/Unfavorite iceon
        tableView.delegate = self
        print("TableView- viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        print("TableView- viewDidAppear")
    }
}

// MARK: - TableView with SwipeTableCell

extension TableViewController: UITableViewDataSource, SwipeTableViewCellDelegate, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryCases?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        let couCase = countryCases![indexPath.row]
        cell.textLabel?.text = "\(couCase.countryName), cases: \(Common.formatNum(couCase.totalConfirmed))"
        
        if countryCases![indexPath.row].favorite == true {
            cell.imageView?.image = UIImage(named: "Favorite")
        } else {
            cell.imageView?.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        // Set-up icon based on favorite in Realm
        let icon = countryCases?[indexPath.row].favorite == true ? "Unfavorite" : "Favorite"
        
        let updateAction = SwipeAction(style: .destructive, title: icon) { action, indexPath in
            // Handle action by updating model with deletion
            do {
                try self.realm.write {
                    self.countryCases?[indexPath.row].favorite = !(self.countryCases?[indexPath.row].favorite)!
               }
           } catch {
               print("Error Updating Realm with Corona Cases, \(error)")
               return
           }
            // Reload tableView and Scroll to the top of tableView
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        // Customize the action appearance
        updateAction.image = UIImage(named: icon)
        updateAction.backgroundColor = .white
        updateAction.textColor = .black
        return [updateAction]
    }
    
    // When cell is tapped, go to CountryDetailViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callCountryDetailVC(countryName: countryCases![indexPath.row].countryName)
    }
}

// MARK: - Search Bar Delegate
extension TableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        countryCases = countryCases?.filter("countryName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "countryName", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCases()
            tableView.reloadData()
            DispatchQueue.main.async {
                // searchBar relinquish FirstRespomder
                searchBar.resignFirstResponder()
            }
        }
    }
}
