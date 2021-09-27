//
//  RemarkCollectionViewCell.swift
//  LandmarkRemark
//
//  Created by Arvin on 26/9/21.
//

import UIKit

class RemarkCollectionViewCell: UICollectionViewCell {
    
    // reuse identifier
    static let reuseId = "RemarkCollectionViewCell"
    
    // MARK: Properties
    
    var noteTitleLabel = UILabel()
    var separatorView = LRSeparatorView()
    var textStackview = UIStackView()
    var latitudeLabel = UILabel()
    var longitudeLabel = UILabel()
    
    // will be useful when we need to bind multiple values from our viewModel to our cell
    var remarkViewModel: RemarkViewModel? {
        didSet { bindValues() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup methods
    
    private func setup() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        // Note title
        noteTitleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        noteTitleLabel.textColor = .label
        noteTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteTitleLabel)

        // Container view for Lat and Long labels
        textStackview.axis = .horizontal
        textStackview.alignment = .fill
        textStackview.distribution = .fillProportionally
        textStackview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textStackview)
        
        // latitude and longitude labels
        latitudeLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        latitudeLabel.textColor = .secondaryLabel
        textStackview.addArrangedSubview(latitudeLabel)
        
        longitudeLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        longitudeLabel.textColor = .secondaryLabel
        textStackview.addArrangedSubview(longitudeLabel)
        
        addSubview(separatorView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Note Title
            noteTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.padding),
            noteTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Space.padding),
            noteTitleLabel.bottomAnchor.constraint(equalTo: textStackview.topAnchor, constant: -Space.padding),
            
            // container view
            textStackview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.padding),
            textStackview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Space.padding),
            textStackview.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -Space.padding),
            
            // separator
            separatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: Bind values
    /**
     * Bind viewModel's values to cell's view properties for display
     */
    private func bindValues() {
        noteTitleLabel.text = remarkViewModel?.title
        latitudeLabel.text = "Latitude: \(remarkViewModel?.latitude ?? 0.0)"
        longitudeLabel.text = "Latitude: \(remarkViewModel?.longitude ?? 0.0)"
    }
}
