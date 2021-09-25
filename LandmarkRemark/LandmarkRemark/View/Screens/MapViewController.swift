//
//  ViewController.swift
//  LandmarkRemark
//
//  Created by Arvin Quiliza on 9/19/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    var infoButton = UIButton()
    
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
        
        infoButton.backgroundColor = .black
        infoButton.alpha = Alpha.mid
        infoButton.setImage(SFSymbols.infoFill, for: .normal)
        infoButton.tintColor = .white
        infoButton.layer.cornerRadius = Space.cornerRadius
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Space.padding),
            infoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Space.padding),
            infoButton.heightAnchor.constraint(equalToConstant: Size.buttonHeight),
            infoButton.widthAnchor.constraint(equalTo: infoButton.heightAnchor),
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
    
    @objc private func infoButtonTapped() {
        print("infoButtonTapped")
    }

}

extension MapViewController: CLLocationManagerDelegate {
    
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


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let title = view.annotation?.title else { return }
        
        let currentLocationInfoVC = CurrentLocationInfoViewController()
        currentLocationInfoVC.titleText = title
        currentLocationInfoVC.coordinates = view.annotation?.coordinate
        
        
        if #available(iOS 15.0, *) {
            if let sheet = currentLocationInfoVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersGrabberVisible = true
            }
            present(currentLocationInfoVC, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            let navController = UINavigationController(rootViewController: currentLocationInfoVC)
            present(navController, animated: true, completion: nil)
        }
    }
}
