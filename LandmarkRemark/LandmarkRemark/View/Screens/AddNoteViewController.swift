//
//  AddNoteViewController.swift
//  LandmarkRemark
//
//  Created by Arvin on 24/9/21.
//

import UIKit
import MapKit

class AddNoteViewController: UIViewController {
    
    // MARK: Properties
    
    var coordinates: CLLocationCoordinate2D?
    
    var defaultTitle: String?
    var latitudeLabel = UILabel()
    var longitudeLabel = UILabel()
    var separatorView = LRSeparatorView()
    
    var titleLabel = UILabel()
    var titleTextField = UITextField()
    var noteLabel = UILabel()
    var noteTextView = LRTextView()
    var saveNoteButton = UIButton()
    
    // Boolean values used for enabling/disabling save button based on the user's text field/view activity
    var isNoteTitleChange: Bool = false { didSet { setDidValueChanged() } }
    var isNoteTextChange : Bool = false { didSet { setDidValueChanged() } }
    var shouldEnableSave : Bool = false { didSet { enableSaveButton() } }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Setup methods
    
    private func setup() {
        setupView()
        setupConstraints()
    }
    
    // setup UI element's properties
    private func setupView() {
        title = "Add Note"
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
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
        
        // notes title label
        titleLabel.text = "Title"
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        //titleTextField
        titleTextField.delegate = self
        titleTextField.placeholder = "e.g. Famous landmark..."
        titleTextField.textColor = .label
        titleTextField.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        
        // notes label
        noteLabel.text = "Note"
        noteLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        noteLabel.textColor = .secondaryLabel
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteLabel)
        
        // note textview
        noteTextView.placeholder = "Give a short note for this location"
        noteTextView.changeDelegate = self
        view.addSubview(noteTextView)
        
        // addNoteButton
        saveNoteButton.backgroundColor = .systemBlue
        saveNoteButton.setTitle("Save Notes", for: .normal)
        saveNoteButton.setTitleColor(.white, for: .normal)
        saveNoteButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        saveNoteButton.layer.cornerRadius = Space.cornerRadius
        saveNoteButton.addTarget(self, action: #selector(saveNoteTapped), for: .touchUpInside)
        saveNoteButton.isEnabled = false
        saveNoteButton.alpha = Alpha.mid
        saveNoteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveNoteButton)
    }
    
    // constraints setup for UI elements
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            // longitude and latitude
            latitudeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Space.padding),
            latitudeLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            latitudeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Space.padding),

            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: Space.padding),
            longitudeLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            longitudeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Space.padding),
            
            // separator view
            separatorView.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: Space.adjacent),
            separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            separatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            
            // titles label and textField
            titleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Space.adjacent),
            titleLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  Space.padding),
            
            titleTextField.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Space.padding),
            
            // note's label and textfield
            noteLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Space.adjacent),
            noteLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Space.padding),
            
            noteTextView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: Space.padding),
            noteTextView.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            noteTextView.heightAnchor.constraint(equalToConstant: Size.textViewHeight),
            
            // save button
            saveNoteButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: Space.adjacent),
            saveNoteButton.widthAnchor.constraint(equalTo: separatorView.widthAnchor),
            saveNoteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveNoteButton.heightAnchor.constraint(equalToConstant: Size.buttonHeight)
        ])
    }
 
    /**
     * Invoke addRemark action that adds remark based on the values keyed in by the user. We create a viewModel instance based on this values and
     * send the view model instance to our persistence manager to facilitate the saving.
     */
    @objc private func saveNoteTapped() {
        guard let coordinates = coordinates else { return }

        let title = titleTextField.text ?? defaultTitle ?? "My Location"
        let noteText = noteTextView.text ?? ""
        
        let remarkViewModel = RemarkViewModel(title: title, note: noteText, coordinate: coordinates)
        
        dismiss(animated: true) {
            // call the addRemark action on viewModel manager passing in created remarkViewModel
            ViewModelManager.shared.addRemark(remarkViewModel: remarkViewModel) { [weak self] error in
                guard let self = self else { return }
                
                guard error == nil else {
                    self.presentAlert(withTitle: "Add Remark", andMessage: error!.rawValue, buttonTitle: "Ok")
                    return
                }
            }
        }
    }
    
    /// Dismiss AddNote view controller
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    /// We enable save button if e both have texts inputted in Note textView and title textField
    private func setDidValueChanged() {
        shouldEnableSave = isNoteTitleChange && isNoteTextChange
    }
    
    /// We control saveNote button's accessibility based on shouldEnableSave value. Please see setDidValueChanged method to check the shouldEnableSave is being configured
    private func enableSaveButton() {
        UIView.animate(withDuration: Animation.duration) {
            self.saveNoteButton.alpha = self.shouldEnableSave ? 1.0 : 0.5
            self.saveNoteButton.isEnabled = self.shouldEnableSave
        }
    }
}

extension AddNoteViewController: UITextFieldDelegate, LRTextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // if textField is empty
        isNoteTitleChange = !(textField.text?.isEmpty ?? true)
    }
    
    func lrTextViewDidChange(_ textView: LRTextView) {
        // if textView is empty and textView is equal to placeholder
        isNoteTextChange = textView.text != "" && textView.text != textView.placeholder
    }
}
