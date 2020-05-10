//
//  FlickrData.swift
//  VirtualTourist
//
//  Created by msuzuki on 5/9/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation

struct FlickrData: Codable {
    let photos: FlickrPhotos?
}

struct FlickrPhotos: Codable{
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [FlickrPhoto]
}

struct FlickrPhoto: Codable{
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}
