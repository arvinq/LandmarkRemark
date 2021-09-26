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
    
    var noteTitleLabel = UILabel()
    var separatorView = LRSeparatorView()
    
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
        
        noteTitleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        noteTitleLabel.textColor = .label
        noteTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteTitleLabel)
        
        addSubview(separatorView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            noteTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.padding),
            noteTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Space.padding),
            noteTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: Bind values
    
    private func bindValues() {
        noteTitleLabel.text = remarkViewModel?.title
    }
}
