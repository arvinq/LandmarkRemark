//
//  Constant.swift
//  LandmarkRemark
//
//  Created by Arvin Quiliza on 9/22/21.
//

import UIKit

enum Map {
    static let regionInMeters: Double = 1000
}

enum Space {
    static let padding: CGFloat = 8.0
    static let adjacent: CGFloat = 16.0
    static let cornerRadius: CGFloat = 5.0
}

enum Size {
    static let buttonHeight: CGFloat = 40.0
    static let separatorHeight: CGFloat = 1.0
    static let textViewHeight: CGFloat = 70.0
}

enum Animation {
    static let duration: CGFloat = 0.35
}

enum Alpha {
    static let mid: CGFloat = 0.5
    static let solid: CGFloat = 1.0
    static let none: CGFloat = 0.0
    static let strongFade: CGFloat = 0.8
    static let weakFade: CGFloat = 0.3
}
