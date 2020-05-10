//
//  ViewController.swift
//  VirtualTourist
//
//  Created by msuzuki on 5/8/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        
        
    }
    
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        print(touchMapCoordinate)
        
//        let newPin = Pin(context: dataController.viewContext)
//        newPin.latitude = touchMapCoordinate.latitude
//        newPin.longitude =  touchMapCoordinate.longitude
//        newPin.creationDate = Date()
//        try? dataController.viewContext.save()
//
//        let newAnnotation = CustomPinAnnotation(coordinate: touchMapCoordinate, pin: newPin)
//        mapView.addAnnotation(newAnnotation)
    }


}

