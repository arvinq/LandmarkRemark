//
//  CurrentLocationInfoViewController.swift
//  LandmarkRemark
//
//  Created by Arvin on 24/9/21.
//

import UIKit
import MapKit

class CurrentLocationInfoViewController: UIViewController {

    var titleText: String?
    var coordinates: CLLocationCoordinate2D?
    
    var annotationTitle = UILabel()
    var latitudeLabel = UILabel()
    var longitudeLabel = UILabel()
    var addNoteButton = UIButton()
    var separatorView = LRSeparatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotes()
    }

    private func setup() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
        // annotationLabel (create a custom label for annotation label and lat/long labels)
        annotationTitle.textAlignment = .left
        annotationTitle.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        annotationTitle.textColor = .label
        annotationTitle.translatesAutoresizingMaskIntoConstraints = false
        annotationTitle.text = titleText
        view.addSubview(annotationTitle)
        
        // latitude and longitude labels
        latitudeLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        latitudeLabel.textColor = .secondaryLabel
        latitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        longitudeLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        longitudeLabel.textColor = .secondaryLabel
        longitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        if let coordinates = coordinates {
            latitudeLabel.text = "Latitude: \(coordinates.latitude)"
            longitudeLabel.text = "Longitude: \(coordinates.longitude)"
        }
        view.addSubview(latitudeLabel)
        view.addSubview(longitudeLabel)
        
        // separator view
        view.addSubview(separatorView)
        
        // addNoteButton
        addNoteButton.backgroundColor = .systemBlue
        addNoteButton.setTitle("Add Notes", for: .normal)
        addNoteButton.setTitleColor(.white, for: .normal)
        addNoteButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        addNoteButton.layer.cornerRadius = Space.cornerRadius
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNoteButton)
    }
    
    private func setupConstraints() {
        
        var topPadding = Space.padding

        if #available(iOS 15.0, *) {
            topPadding = topBarHeight
        }
        
        NSLayoutConstraint.activate([
            annotationTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            annotationTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.padding),
            annotationTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Space.padding),
            
            latitudeLabel.topAnchor.constraint(equalTo: annotationTitle.bottomAnchor, constant: Space.padding),
            latitudeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.padding),
            latitudeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Space.padding),

            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: Space.padding),
            longitudeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.padding),
            longitudeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Space.padding),
            
            separatorView.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: Space.adjacent),
            separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            separatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            
            addNoteButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Space.adjacent),
            addNoteButton.widthAnchor.constraint(equalTo: separatorView.widthAnchor),
            addNoteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNoteButton.heightAnchor.constraint(equalToConstant: Size.buttonHeight)
        ])
    }
    
    private func setupNotes() {
        //check DB first if we have a note, else, we will show the addNote button
//        addNoteButton.isHidden = true
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
