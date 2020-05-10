//
//  Flickr.swift
//  VirtualTourist
//
//  Created by msuzuki on 5/9/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//


import Foundation
import MapKit

class Flickr {
    
    struct Auth {
        static let key = "3cff17f98d4238b8de6cfb81ee25863a"
        static let secret = "d5d6e791d77b4d34"
    }
    
    enum EndPoint {
        case search(PinAnnotation)
        case load([String:String], Int)
        
        var endPointString: String {
            switch self {
            case .search(let pinAnnotation):
                return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Auth.key)&lat=\(pinAnnotation.coordinate.latitude)&lon=\(pinAnnotation.coordinate.longitude)&radius=20&per_page=30&page=\(Int.random(in: 1..<10))&format=json"
            case .load(let data, let farmID):
                return "https://farm\(farmID).staticflickr.com/\(data["Server"]!)/\(data["ID"]!)_\(data["Secret"]!).jpg"
            }
        }
        
        var url: URL {
            return URL(string: endPointString)!
        }
    }
}


// MARK: - Search Images within a 20kms radius from pinAnnotation. pinAnnotation holds the coordinates and inherits from MKAnnotation (MapKit)
extension Flickr {
    static func search(pinAnnotation: PinAnnotation, completion: @escaping (_ result: Data?, _ error: String? )-> Void) {
        let request = URLRequest(url: EndPoint.search(pinAnnotation).url)
            
             let task = URLSession.shared.dataTask(with: request) {data, response, error in
                              // GUARD: Check for Errors
                              guard error == nil else {
                                  completion(nil, "Request Error: \(String(describing: error))")
                                  return
                              }
                              // GUARD: Successful 2xx Response?
                              guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                                  completion(nil, "Request returned Status Code Other than 2xx!")
                                  return
                              }
                              // GUARD: Any Data Returned?
                              guard data != nil else {
                                print("Three is not data")
                                  completion(nil, "Request returned NO Data!")
                                  return
                              }
                       completion(data, nil)
                          }
                          task.resume()
        }
}

// MARK: - Load Image from Flickr
extension Flickr {
    static func load(photoData: FlickrPhoto, completion: @escaping (_ result: Data?, _ error: String?)->Void) {

        let request = URLRequest(url: EndPoint.load(
                                            ["Server": photoData.server ,
                                             "ID": photoData.id,
                                             "Secret": photoData.secret]
                                            , photoData.farm).url)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            // GUARD: Check for Errors
            guard error == nil else {
                completion(nil, "\(error!)")
                return
            }
            // GUARD: Successful 2xx Response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, "Request returned Status Code Other than 2xx!")
                return
            }
            // GUARD: Any Data Returned?
            guard data != nil else {
                completion(nil, "Request returned NO Data!")
                return
            }

            completion(data, nil)
        }
        task.resume()
        
    }
}
