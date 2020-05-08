//
//  CountryDetailViewController.swift
//  Covid19
//
//  Created by msuzuki on 5/7/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import RealmSwift

class CountryDetailViewController: UIViewController {
    
    var realm = try! Realm()
    
    var cname: String = ""
    
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var totalConfirmed: UILabel!
    @IBOutlet weak var totalRecovered: UILabel!
    @IBOutlet weak var totalDeaths: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let countryDetail = realm.objects(Case.self).filter("countryName like %@", cname)
        countryName.text = cname
        date.text =  defaults.string(forKey: "lastUpdate")!
        totalConfirmed.text = Common.formatNum(countryDetail[0].totalConfirmed)
        totalRecovered.text = Common.formatNum(countryDetail[0].totalRecovered)
        totalDeaths.text = Common.formatNum(countryDetail[0].totalDeaths)
    }
}
