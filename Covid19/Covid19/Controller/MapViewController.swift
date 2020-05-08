//
//  MapViewController.swift
//  Covid19
//
//  Created by msuzuki on 5/7/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MapViewController: UpdateCasesViewController {

    var locationManager: CLLocationManager = CLLocationManager()
    var annotations = [MKPointAnnotation]()
    var zoomView: Double?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("MapView - viewDidAppear")
        loadCases()
        zoomView = mapView.visibleMapRect.size.width
        overlayAnnotations(caller: "viewDidLoad")
    }
}

// MARK: - Method Overlay Annotations and Circles
extension MapViewController {
    func overlayAnnotations(caller: String) {

        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        annotations = []
        let annotationLabels = mapView.annotations
        mapView.removeAnnotations(annotationLabels)
        
        for c in countryCases! {
            let latDouble = Double(c.lat)
            let lonDouble = Double(c.lon)
            let latitude = CLLocationDegrees(truncating: NSNumber(value: latDouble))
            let longitude = CLLocationDegrees(truncating: NSNumber(value: lonDouble))
            let location = CLLocation(latitude: latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees)

            self.zoomView = self.mapView.visibleMapRect.size.width
            var radius = (log10(Float(c.totalConfirmed)) * Float(self.zoomView!) / 500)

            if radius.isInfinite  {
                radius = 0
            }

            let circle = MKCircle(center: location.coordinate, radius: Double(radius) as CLLocationDistance)

            DispatchQueue.main.async {
                self.mapView.addOverlay(circle)
            }

            DispatchQueue.main.async {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = ("\(c.countryName)")
                annotation.subtitle = Common.formatNum(c.totalConfirmed)
                self.annotations.append(annotation)
            }
        }
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(annotationLabels)
            self.mapView.addAnnotations(self.annotations)
        }
    }
}
// MARK: - MapView Delegates
extension MapViewController: MKMapViewDelegate {
    // Create Custom Annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "country"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "country")
        }
        DispatchQueue.main.async {
            // Create Custom Image with Label for Annotation
            var imageview = UIImageView()
            imageview = UIImageView(frame: CGRect(x: -15, y: -15, width: 100, height: 50))
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 1, width: 100, height: 30)
            label.textAlignment = .left
            label.font = UIFont.boldSystemFont(ofSize: 10)
            label.textColor = UIColor.black
            label.text = annotation.subtitle!
            imageview.addSubview(label)
                            
            annotationView?.subviews.forEach { $0.removeFromSuperview() }
            annotationView!.addSubview(imageview)
            // Show callout and on-click functionality
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return annotationView
    }
    
    // Renderer Circle Overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.fillColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5)
            circle.strokeColor = .red
            circle.lineWidth = 1
            return circle
        } else {
            return MKOverlayRenderer()
        }
    }
    
    // When Zoom Changes, Trigger Resize Circle Overlays
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let zoomWidth = mapView.visibleMapRect.size.width
        let zoomFactor = Int(log2(zoomWidth)) - 9
        overlayAnnotations(caller: "ZoomDidChange")
    }
    
    // On-click push to CountryDetailViewController
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            callCountryDetailVC(countryName: (view.annotation?.title!)!)
        }
    }
}
