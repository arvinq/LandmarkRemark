//
//  SeparatorView.swift
//  LandmarkRemark
//
//  Created by Arvin on 24/9/21.
//

import UIKit

class LRSeparatorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor = .tertiaryLabel) {
        self.init(frame: CGRect.zero)
        backgroundColor = color
    }
    
    private func setup() {
        backgroundColor = .tertiaryLabel
        translatesAutoresizingMaskIntoConstraints = false
    }
}
