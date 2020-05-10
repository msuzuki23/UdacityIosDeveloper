//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by msuzuki on 5/8/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pins = [Pin]()
    
    var images = [Image]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [PinAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPins()
        createPins()
        addLongPressRecognizer()
    }
    
    func loadPins(with request: NSFetchRequest<Pin> = Pin.fetchRequest()) {
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            pins = try context.fetch(request)
            
        } catch {
            print("Error fecthing data from context, \(error)")
        }
    }

}

// MARK: - Method addLongPressRecognizer for mapView
extension MapViewController {
    func addLongPressRecognizer() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }
        
        let tapPin = gestureRecognizer.location(in: mapView)
        let pin = mapView.convert(tapPin, toCoordinateFrom: mapView)
        
        print(pin)
        let newPin = Pin(context: context)
        newPin.lat = pin.latitude
        newPin.lon = pin.longitude
        newPin.date = Date()
        pins.append(newPin)
        
        do {
            try context.save()
            createPin(newPin)
            mapView.addAnnotations(annotations)
            let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            let annotation = PinAnnotation(coordinate: coordinate, pin: newPin)
            
        } catch {
            print("Error in Saving new pin to DB, \(error)")
        }
    }
}

// MARK: - Method createPins
extension MapViewController {
    func createPins() {
        for p in pins {
            createPin(p)
        }
        mapView.addAnnotations(annotations)
    }
    
    func createPin(_ newPin: Pin) {
        let lat = CLLocationDegrees(newPin.lat)
        let lon = CLLocationDegrees(newPin.lon)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotation = PinAnnotation(coordinate: coordinate, pin: newPin)
        annotations.append(annotation)
    }
}

// MARK: - mapView Delegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let selectedAnnotations = mapView.selectedAnnotations
        for annotation in selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: false)
        }
        
        let pinAnnotation = view.annotation as! PinAnnotation
        
        let collectionVC: CollectionViewController = storyboard?.instantiateViewController(identifier: "TestViewController") as! CollectionViewController
        collectionVC.pinAnnotation = pinAnnotation
        self.navigationController?.pushViewController(collectionVC, animated: true)
        
    }
}
