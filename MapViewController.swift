//
//  MapViewController.swift
//  Memorable Places
//  Mini project from Udemy (iOS10 & Swift 3 complete developer) course
//
//  Created by admin on 09/01/2018.
//  Copyright © 2018 Josh_Dog101. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var places      = [Dictionary<String, String>()]
    var activePlace = -1
    var manager     = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longpress(gestureRecognizer:)))
        
        longPressRecognizer.minimumPressDuration = 2
        map.addGestureRecognizer(longPressRecognizer)
        
        if activePlace == -1 {
            
            // code to center the map on the user's curent location
            manager.delegate        = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        } else {
            
            // get place details to display on map
            if places.count > activePlace {
                if let name = places[activePlace]["name"] {
                    if let lat = places[activePlace]["lat"] {
                        if let lon = places[activePlace]["lon"] {
                            if let latitude = Double(lat) {
                                if let longitude = Double(lon) {
                                    let span       = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    let region     = MKCoordinateRegion(center: coordinate, span: span)
                                    self.map.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    
                                    annotation.coordinate = coordinate
                                    annotation.title      = name
                                    self.map.addAnnotation(annotation)
                                }
                            }
                        }
                    }
                }
            }
        }
        print(activePlace)
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchpoint    = gestureRecognizer.location(in: self.map)
            let newCoordinate = self.map.convert(touchpoint, toCoordinateFrom: self.map)
            let location      = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var title         = ""
            
            // attempt the reverse GEOcode
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    }
                }
                
                // if the reverse GEOcode is not successful the the title will become: Added (Date)
                if title == "" {
                    title = "Added \(NSDate())"
                }
                
                // add the annotation
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                annotation.title      = title
                self.map.addAnnotation(annotation)
                
                self.places.append(["name":title, "lat":String(newCoordinate.latitude), "lon":String(newCoordinate.longitude)])
                UserDefaults.standard.set(self.places, forKey: "places")
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span     = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region   = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
    }
}
