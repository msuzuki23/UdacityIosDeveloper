//
//  TestViewController.swift
//  VirtualTourist
//
//  Created by msuzuki on 5/9/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CollectionViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var addImages: UIButton!
    var pinAnnotation: PinAnnotation? {
        didSet {
            getImages()
        }
    }
    var images = [Image]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.addAnnotation(pinAnnotation!)
        centerMapOnLocation(CLLocation(latitude: pinAnnotation!.coordinate.latitude, longitude: pinAnnotation!.coordinate.longitude), mapView: mapView)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20) / 3, height: (self.collectionView.frame.size.height - 20) / 5)
        
    }
    
    @IBAction func loadImages(_ sender: UIButton) {
        addNewImagesFromFlickr()
        getImages()
    }
    

    
    func getImages(with request: NSFetchRequest<Image> = Image.fetchRequest()) {
        let predicate = NSPredicate(format: "pin == %@", pinAnnotation!.pin)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            self.images = try self.context.fetch(request)
            
            if self.images.count == 0 {
                addNewImagesFromFlickr()
            }
        } catch {
            print("error in getting images")
        }
    }
    
    
    func addNewImagesFromFlickr() {
        //self.addImages.isHidden = true
        print("Calling Flickr")
        Flickr.search(pinAnnotation: self.pinAnnotation!) { data, error in
        guard error == nil else {
            print("Error")
            return
        }
        guard data != nil else {
            // Display Alert or label
            print("No Picture for this location")
            return
        }
        let decoded = self.parseJSON(flicker: data!)
            for d in decoded!.photos!.photo {
                Flickr.load(photoData: d) { data, error in
                    guard error == nil else {
                        print("\(error!)")
                        return
                    }
                    guard data != nil else {
                        // Display Alert or label
                        print("No Picture for this location")
                        return
                    }
                    let newImage = Image(context: self.context)
                    newImage.pin = self.pinAnnotation!.pin
                    newImage.image = data!
                    newImage.date = Date()
                    self.images.append(newImage)
                    do {
                        try self.context.save()
                    } catch {
                        print("Error in Saving new pin to DB, \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                }
            }
        }
    }
    
    func parseJSON(flicker: Data) -> FlickrData? {
        let cleanFlicker = flicker.subdata(in: (14..<(flicker.count-1)))
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FlickrData.self, from: cleanFlicker)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}

extension CollectionViewController: MKMapViewDelegate {
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
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 100000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}


extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.cellImage.image = UIImage(data: images[indexPath.row].image!)
        return cell
    }
}




