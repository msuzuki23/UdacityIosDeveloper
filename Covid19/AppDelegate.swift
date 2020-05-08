//
//  AppDelegate.swift
//  Covid19
//
//  Created by msuzuki on 5/5/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let realm = try! Realm()
    let defaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Print Realm file path
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let cases = realm.objects(Case.self)

        if cases.count == 0 {
            seedCases()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Seed Countries and Cases in Realm
    func seedCases() {
        let seeds = Seed.All
        
        for s in seeds {
            let newCase = Case()
            newCase.countryCode = s.key
            newCase.countryName = s.value["countryName"]! as! String
            newCase.lat = (s.value["lat"]! as! NSString).floatValue
            newCase.lon  = (s.value["lon"]! as! NSString).floatValue
            newCase.totalConfirmed = s.value["totalConfirmed"]! as! Int
            newCase.totalDeaths = s.value["totalDeaths"]! as! Int
            newCase.totalRecovered = s.value["totalRecovered"]! as! Int

            // Add countries into Realm, Entity Case
            do {
                try realm.write {
                    realm.add(newCase)
                }
            } catch {
                print("Error saving country, \(error)")
            }
        }
        defaults.set("2020/5/7", forKey: "lastUpdate")
    }
}

