//
//  UpdateCasesViewController.swift
//  Covid19
//
//  Created by msuzuki on 5/6/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import RealmSwift

class UpdateCasesViewController: UIViewController {
    
    let realm = try! Realm()
    var curDate: String = ""
    
    let defaults = UserDefaults.standard
    var countryCases: Results<Case>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // print Realm filepath
        //print(Realm.Configuration.defaultConfiguration.fileURL!)

        getCurDate()    // Get Current Date
        print("Parent VC - viewDidLoad")
        if let lastUpdate = defaults.string(forKey: "lastUpdate") {
            // Check the latest updated Postman Corona Virus Cases
            if curDate != lastUpdate {
                updateRealm()
            } else {
                loadCases()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCurDate()
        print("Parent VC - viewDidAppear")
        if let lastUpdate = defaults.string(forKey: "lastUpdate") {
            // Check the latest updated Postman Corona Virus Cases
            if curDate != lastUpdate {
                updateRealm()
            } else {
                loadCases()
            }
        }
    }
    
    func loadCases() {
        let sortProperties = [SortDescriptor(keyPath: "favorite", ascending: false), SortDescriptor(keyPath: "countryName", ascending: true)]
        countryCases = realm.objects(Case.self).sorted(by: sortProperties)
    }
    
    func callCountryDetailVC(countryName: String) {
        let countryDetailVC: CountryDetailViewController = storyboard?.instantiateViewController(identifier: "CountryDetailVC") as! CountryDetailViewController
        countryDetailVC.cname = countryName
        self.navigationController?.pushViewController(countryDetailVC, animated: true)
    }
}

// MARK: - Get Current Date
extension UpdateCasesViewController {
    func getCurDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        curDate = formatter.string(from: Date())
    }
}

// MARK: - Query Postman API. Get Latest Corona Virus Cases Worldwide
extension UpdateCasesViewController {
    func getCovidCases(completionHandler: @escaping (_ result: CovidData?, _ error: String?) -> Void) {
        let urlString = "https://api.covid19api.com/summary"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { d, r, e in
                guard e == nil else {
                    completionHandler(nil, "Error in Requesting Covid-19 Cases from Postman. Error: \(e!)")
                    return
                }
                // GUARD: Successful 2xx Response?
                guard let statusCode = (r as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    completionHandler(nil, "Request returned Status Code Other than 2xx!")
                    return
                }
                // GUARD: Any Data Returned?
                guard d != nil else {
                    completionHandler(nil, "Request returned NO Data!")
                    return
                }
                let covidJSON = self.parseJSON(covidData: d!)
                completionHandler(covidJSON, nil)
            }
            task.resume()
        }
    }
}

// MARK: - Method ParseJSON
extension UpdateCasesViewController {
    func parseJSON(covidData: Data) -> CovidData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CovidData.self, from: covidData)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}

// MARK: - Update Realm with latest Postman Corona Virus Cases
extension UpdateCasesViewController {
    func updateRealm() {
        DispatchQueue.main.async {
            self.getCovidCases { result, error in
                // Check for Errors
                guard error == nil  else {
                    print(error!)
                    return
                }
                // Check if result is nil
                guard result != nil else {
                    print("Results from Postman Corona Virus Cases are nil.")
                    return
                }
                // Query Case in Realm
                let realmC = try! Realm()
                let realmCases = realmC.objects(Case.self)
                
                // Update Realm with the latest Corona Virus cases from postman
                for c in result!.Countries {
                    let countryCase = realmCases.first(where: { $0.countryCode == c.CountryCode })!
                    do {
                        try realmC.write {
                            countryCase.totalConfirmed = c.TotalConfirmed
                            countryCase.totalDeaths = c.TotalDeaths
                            countryCase.totalRecovered = c.TotalRecovered
                        }
                    } catch {
                        print("Error Updating Realm with Corona Cases, \(error)")
                        return
                    }
                }
                self.defaults.set(self.curDate, forKey: "lastUpdate")
                print("After Realm Updates: \(self.defaults.string(forKey: "lastUpdate")!)")
            }
        }
    }
}
