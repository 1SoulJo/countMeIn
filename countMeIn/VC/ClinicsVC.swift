//
//  ClinicsVC.swift
//  countMeIn
//
//  Created by Hansol Jo on 2021-03-24.
//

import UIKit
import MapKit

class ClinicsVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        map?.delegate = self
        
        // Get current location
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        location = CLLocationCoordinate2D(
            latitude: CLLocationDegrees.init(exactly: locValue.latitude)!,
            longitude: CLLocationDegrees.init(exactly: locValue.longitude)!)
        
        annotation.title = "My Location"
        annotation.coordinate = location!
        map?.mapType = .standard
        map?.addAnnotation(annotation)
        
        centerMapLocation(location!, mapView: map!)
    }
    
    func centerMapLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 10000
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        map.setRegion(region, animated: true)
    }
}
