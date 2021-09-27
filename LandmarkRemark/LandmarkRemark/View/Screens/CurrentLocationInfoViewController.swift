//
//  CurrentLocationInfoViewController.swift
//  LandmarkRemark
//
//  Created by Arvin on 24/9/21.
//

import UIKit
import MapKit

class CurrentLocationInfoViewController: UIViewController {

    // MARK: Properties
    
    var titleText: String?
    var coordinates: CLLocationCoordinate2D?
    
    var annotationTitle = UILabel()
    var latitudeLabel = UILabel()
    var longitudeLabel = UILabel()
    var addNoteButton = UIButton()
    var separatorView = LRSeparatorView()
    
    var titleLabel = UILabel()
    var noteLabel = UILabel()
    var noteTextView = LRTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotes()
    }

    // MARK: Setup methods
    
    private func setup() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
        // annotationLabel (create a custom label for annotation label and lat/long labels)
        annotationTitle.textAlignment = .left
        annotationTitle.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        annotationTitle.textColor = .label
        annotationTitle.translatesAutoresizingMaskIntoConstraints = false
        annotationTitle.text = titleText
        view.addSubview(annotationTitle)
        
        // latitude and longitude labels
        latitudeLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        latitudeLabel.textColor = .secondaryLabel
        latitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        longitudeLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
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
        addNoteButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNoteButton)
        
        // notes title label
        titleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // notes label
        noteLabel.text = "Note:"
        noteLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        noteLabel.textColor = .secondaryLabel
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteLabel)
        
        view.addSubview(noteTextView)
    }
    
    private func setupConstraints() {
        
        // Hitting an issue with Sheet Presentation Controller with navigation bar, hence we just made a condition to assign correct padding for the top most UI element. If we're using Sheet Presentation (when iOS 15 is used), we then use the top bar height property of the view controller. Else we just use the normal padding.
        var topPadding = Space.padding

        if #available(iOS 15.0, *) {
            topPadding = topBarHeight
        }
        
        NSLayoutConstraint.activate([
            annotationTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            annotationTitle.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            annotationTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Space.padding),
            
            latitudeLabel.topAnchor.constraint(equalTo: annotationTitle.bottomAnchor, constant: Space.padding),
            latitudeLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            latitudeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Space.padding),

            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: Space.padding),
            longitudeLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            longitudeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Space.padding),
            
            separatorView.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: Space.adjacent),
            separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            separatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            
            addNoteButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Space.adjacent),
            addNoteButton.widthAnchor.constraint(equalTo: separatorView.widthAnchor),
            addNoteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNoteButton.heightAnchor.constraint(equalToConstant: Size.buttonHeight),
            
            titleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Space.adjacent),
            titleLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  Space.padding),
            
            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Space.adjacent),
            noteLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Space.padding),
            
            noteTextView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: Space.padding),
            noteTextView.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            noteTextView.heightAnchor.constraint(equalToConstant: Size.textViewHeight),
        ])
    }
    
    /**
     * Get the list of Remarks from Firestore. We then retrieve the  correct remark based on the selected current locations' coordinate to populate the UI elements.
     */
    private func setupNotes() {
        //check DB first if we have a note, else, we will show the addNote button
        ViewModelManager.shared.getRemarks { [weak self] error in
            guard let self = self else { return }
            
            // if error is present when retrieving the remarks, we automatically hide the controls and show add button
            guard error == nil else {
                self.setupViewVisibility(using: false)
                return
            }
            
            // if no coordinates is passed (which is highly unlikely) and there's no remark on the location, then we show add button
            guard let coordinates = self.coordinates,
                  let remarkViewModel = ViewModelManager.shared.getRemark(on: coordinates) else {
                      self.setupViewVisibility(using: false)
                      return
            }
            
            // if everything is good, we populate the fields and hide our addButton
            self.setupViewVisibility(using: true)
            self.titleLabel.text = remarkViewModel.title
            self.noteTextView.text = remarkViewModel.note
        }
    }
    
    /**
     * Configure some of the view's visibility on whether to show it or not in the app depending on the isHidden parameter passed on to it.
     *
     * - Parameters:
     *      - isHidden: boolean value to control view's hidden property
     */
    private func setupViewVisibility(using isHidden: Bool) {
        // no remarks yet
        addNoteButton.isHidden = isHidden
        
        // show remarks properies
        titleLabel.isHidden = !isHidden
        noteLabel.isHidden = !isHidden
        noteTextView.isHidden = !isHidden
    }
    
    /**
     * Presents AddNote View Controller to add a remark on a specific location represented by the current coordinates.
     */
    @objc private func addNoteTapped() {
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.coordinates = coordinates
        
        let navController = UINavigationController(rootViewController: addNoteViewController)
        present(navController, animated: true)
    }
    
    /// Dismiss CurrentLocation view controller
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
