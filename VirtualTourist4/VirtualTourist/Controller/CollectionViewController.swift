//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by msuzuki on 5/10/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CollectionViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var addImages: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        addImages.isHidden = false
        activityIndicator.isHidden = true
        // Add Pin Annotation to mapView
        mapView.addAnnotation(pinAnnotation!)
        // Call Center on Map Method to center mapView
        centerMapOnLocation(CLLocation(latitude: pinAnnotation!.coordinate.latitude, longitude: pinAnnotation!.coordinate.longitude), mapView: mapView)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20) / 3, height: (self.collectionView.frame.size.height - 20) / 5)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        images = []
    }
    
    @IBAction func loadImages(_ sender: UIButton) {
        addNewImagesFromFlickr()    // Call addNewImages from Flickr to CoreData
        getImages()
    }
    
    func querying() {
        DispatchQueue.main.async {
            print(self.addImages.isHidden)
            self.addImages.isHidden = !self.addImages.isHidden
            self.activityIndicator.isHidden = !self.activityIndicator.isHidden
            print(self.addImages.isHidden)
        }
    }
}

extension CollectionViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(button)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - getImages from CoreData
extension CollectionViewController {
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
}
    
// MARK: - Add New Images from Flickr to Core Data
extension CollectionViewController {
    func addNewImagesFromFlickr() {
        Flickr.search(pinAnnotation: self.pinAnnotation!) { data, error in
        guard error == nil else {
            print("Error")
            return
        }
        guard data != nil else {
            // Display Alert or label
            //print("No Picture for this location")
            self.showAlert(title: "No Picture", message: "Sorry, no picture for this location.")
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
                        //print("No Picture for this location")
                        self.showAlert(title: "No Picture", message: "Sorry, no picture for this location.")
                        return
                    }
                    let newImage = Image(context: self.context)
                    newImage.pin = self.pinAnnotation!.pin
                    newImage.image = data!
                    newImage.date = Date()
                    self.images.append(newImage)
                    do {
                        try self.context.save()
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } catch {
                        print("Error in Saving new pin to DB, \(error)")
                        return
                    }
                }
            }
        }
    }
}

// MARK: - Parse JSON from flickr
extension CollectionViewController {
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

// MARK: - Mapview
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

// MARK: - CollectionView
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.cellImage.image = UIImage(data: images[indexPath.row].image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        context.delete(images[indexPath.row])
        do {
            try context.save()
        } catch {
            print("Error in deleting Image in CoreData, error \(error)")
        }
        images.remove(at: indexPath.row)
        collectionView.reloadData()
    }
}
