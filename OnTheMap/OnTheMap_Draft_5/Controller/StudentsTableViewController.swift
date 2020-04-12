//
//  StudentsTableViewController.swift
//  OnTheMap_Draft_5
//
//  Created by msuzuki on 3/22/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit

class StudentsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Variables
    var studentsTable: [Student] = []
    @IBOutlet weak var tableView: UITableView!
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        toggleNavButton()
    }
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        toggleNavButton()
        Map().method(method: "getAllLocations", mapString: nil, latitude: nil, longitude: nil, mediaURL: nil) { (locations, error) in
            DispatchQueue.main.async {
                if (locations != nil) {
                    // Forming Array for tableView
                    for l in locations as! [[String : AnyObject]] {
                        if l["firstName"] != nil && l["firstName"]! as! String != "" && l["lastName"] != nil && l["lastName"]! as! String != "" && l["mediaURL"] != nil && l["mediaURL"]! as! String != ""{
                                self.studentsTable.append(Student(firstName: l["firstName"] as! String, lastName: l["lastName"] as! String, mediaURL: l["mediaURL"] as! String))
                        }
                    }
                    self.tableView.reloadData()
                } else {
                    //print("Error: \(error!)")
                    Common.displayError(viewController: self, title: "Display Locations", message: "Could NOT Display Locations at this time. Try again later.")  // From Common Class
                }
            }
        }
    }
    
    // MARK: - tableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsTable.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseIdentifier")
        cell?.textLabel?.text = "\(studentsTable[indexPath.row].firstName), \(studentsTable[indexPath.row].lastName)"
        
        print("Student Name: \(studentsTable[indexPath.row].firstName), \(studentsTable[indexPath.row].lastName)")
        
        return cell!
    }
    // MARK: - tableView didSelectRow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath
        if let link: String = studentsTable[index.row].mediaURL {
            let url = URL(string: link)
            if url != nil {
                UIApplication.shared.open(url!) {success in
                    if !success {
                        Common.displayError(viewController: self, title: "URL Connection Failed", message: "Invalid URL.")
                    }
                }
            }
        }
    }
    // MARK: - Toogle Nav Buttons
    func toggleNavButton() {
        self.navigationController!.navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
        self.navigationController!.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.clear
    }
}
