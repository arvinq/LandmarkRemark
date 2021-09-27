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

    // MARK: Properties
    
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

    // MARK: Setup methods
    
    private func setup() {
        setupViews()
        setupConstraints()
        setupObserver()
    }
    
    private func setupViews() {
        // mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        // info button
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
            // mapview
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            //info button
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Space.padding),
            infoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Space.padding),
            infoButton.heightAnchor.constraint(equalToConstant: Size.buttonHeight),
            infoButton.widthAnchor.constraint(equalTo: infoButton.heightAnchor),
        ])
    }
    
    private func setupObserver() {
        // center to location when selected from remarks list
        NotificationCenter.default.addObserver(forName: .LRCenterToSelectedLocation, object: nil, queue: nil) { [weak self] notification in
            
            guard let self = self else { return }
            
            if let remarkViewModel = notification.userInfo?["remarkViewModel"] as? RemarkViewModel {
                self.mapAnnotation(using: remarkViewModel)
            }
        }
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup our location manager if location services is enabled on device level
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert letting the user know they have to turn the location services on for the map to work. (system-wide)
            presentAlert(withTitle: "Location Services Off", andMessage: LRError.locationServicesDisabled.rawValue, buttonTitle: "Ok")
        }
    }

    private func setupLocationManager() {
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
                presentAlert(withTitle: "Location Services Off", andMessage: LRError.locationAuthOff.rawValue, buttonTitle: "Ok")
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                // just show an alert that the location services are restricted for this app
                presentAlert(withTitle: "Location Services Restricted", andMessage: LRError.locationAuthRestricted.rawValue, buttonTitle: "Ok")
                break
            @unknown default:
                break
        }
    }
    
    /**
     * Create a region that centers on the passed location and zoom into or out of the region based on how far the  size of the coordinates from the center.
     *
     * - Parameters:
     *      - location: contains the coordinates where the region is created and zoomed into
     */
    private func zoomViewOnUserLocation(_ location: CLLocation) {
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: Map.regionInMeters, longitudinalMeters: Map.regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    /**
     * Uses the passed remarkViewModel to create a location object used for creating the region to zoom into. Also creates an annotation object from the remark to map it into the MapView
     *
     * - Parameters:
     *      - remark: view model that indicates the location and the annotation to zoom into and map in our map view
     */
    private func mapAnnotation(using remark: RemarkViewModel) {
        
        let remarkLocation = CLLocation(latitude: remark.latitude, longitude: remark.longitude)
        let remarkAnnotation = RemarkAnnotation(title: remark.title, coordinate: remark.coordinate)
        
        let region = MKCoordinateRegion.init(center: remarkLocation.coordinate, latitudinalMeters: Map.regionInMeters, longitudinalMeters: Map.regionInMeters)
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(remarkAnnotation)
    }
    
    /**
     * Function to execute when info button is tapped
     */
    @objc private func infoButtonTapped() {
        let allRemarksInfoVC = AllRemarksInfoViewController()
        
        // For some reason, the sheetPresentationController doesn't work well with NavigationController and since the search controller resides in navigation, using SheetPresentation here doesn't seem to show the search bar.
        
        let navController = UINavigationController(rootViewController: allRemarksInfoVC)
        present(navController, animated: true, completion: nil)
    }

}

// MARK: CLLocationManager Delegate
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

// MARK: MapView Delegate
extension MapViewController: MKMapViewDelegate {
    
    /**
     * Delegate method triggered when selecting an annotation from the map.
     */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let title = view.annotation?.title else { return }
        
        // creates an instance of our currentLocationVC and inject in the values that will be used in that VC
        let currentLocationInfoVC = CurrentLocationInfoViewController()
        currentLocationInfoVC.titleText = title
        currentLocationInfoVC.coordinates = view.annotation?.coordinate
        
        // Use the sheetPresentation Controller to control the size of the sheet presented modally.
        // Only available on ios15 so we revert back to presenting the view controller inside the navigation controller modally.
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
