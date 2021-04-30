//
//  ClinicsVC.swift
//  countMeIn
//
//  Created by Hansol Jo on 2021-03-24.
//

import UIKit
import MapKit
import Firebase

class ClinicsVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var annotations: [MKPointAnnotation] = []
    
    // clinics
    var clinics: [Clinic] = []
    
    // Firebase data
    let ref = Database.database().reference(withPath: "clinics")
    
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
        
        // Init searchbar
        searchBar.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        location = CLLocationCoordinate2D(
            latitude: CLLocationDegrees.init(exactly: locValue.latitude)!,
            longitude: CLLocationDegrees.init(exactly: locValue.longitude)!)
        
        let annotation = MKPointAnnotation()
        annotation.title = "My Location"
        annotation.coordinate = location!
        map?.mapType = .standard
        map?.addAnnotation(annotation)
        annotations.append(annotation)
        
        centerMapLocation(location!, mapView: map!)
    }
    
    func centerMapLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 10000
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        map.setRegion(region, animated: true)
    }
    
    // search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text ?? "")
        self.clinics.removeAll()
        let queryText = searchBar.text ?? ""
        ref.queryOrdered(byChild: "name")
            .queryStarting(atValue: queryText)
            .queryEnding(atValue: queryText + "\u{f8ff}")
            .observe(.value, with: {snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let clinic = Clinic(snapshot: snapshot) {
                        self.clinics.append(clinic)
                        self.updateMap()
                    }
                }
            })
        searchBar.endEditing(true)
    }
    
    private func updateMap() {
        map?.removeAnnotations(self.annotations)
        for clinic in clinics {
            print(clinic.lat, clinic.lng)
            location = CLLocationCoordinate2D(
                latitude: CLLocationDegrees.init(exactly: clinic.lat)!,
                longitude: CLLocationDegrees.init(exactly: clinic.lng)!)
            
            let annotation = MKPointAnnotation()
            annotation.title = clinic.name
            annotation.coordinate = location!
            map?.mapType = .standard
            map?.addAnnotation(annotation)
            self.annotations.append(annotation)
        }
    }
}
