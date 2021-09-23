//
//  ViewController.swift
//  LandmarkRemark
//
//  Created by Arvin Quiliza on 9/19/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLocationServices()
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        // mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup our location manager if location services is enabled on device level
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert letting the user know they have to turn the location services on for the map to work. (system-wide)
        }
    }

    private func setupLocationManager() {
        // location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            case .authorizedAlways:
                // even when the app is in the background
                break
            case .authorizedWhenInUse:
                // only when app is open
                mapView.showsUserLocation = true
                locationManager.startUpdatingLocation()
                break
            case .denied:
                // alert the user that they need to turn on permissions, when they denied in the first place
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                // just show an alert that the location services are restricted for this app
                break
            @unknown default:
                break
        }
    }
    
    private func zoomViewOnUserLocation(_ location: CLLocation) {
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: Map.regionInMeters, longitudinalMeters: Map.regionInMeters)
        mapView.setRegion(region, animated: true)
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // when the user changes location
        guard let location = locations.last else { return }
        zoomViewOnUserLocation(location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // when the user changes the authorization.
        // Also check when user has selected the authorization on initial load to handle each of the authorization accordingly
        checkLocationAuthorization()
    }
}


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("\(String(describing: view.annotation?.coordinate))")
    }
}
