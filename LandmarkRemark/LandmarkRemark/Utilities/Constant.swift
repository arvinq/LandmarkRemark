//
//  Constant.swift
//  LandmarkRemark
//
//  Created by Arvin Quiliza on 9/22/21.
//

import UIKit

/// Constant values for all things related to Map
enum Map {
    static let regionInMeters: Double = 1000
}

/// Constant values that represents Spaces used in the app
enum Space {
    static let padding: CGFloat = 8.0
    static let adjacent: CGFloat = 16.0
    static let cornerRadius: CGFloat = 5.0
}

/// Constant values that represents Sizes used in the app
enum Size {
    static let buttonHeight: CGFloat = 40.0
    static let separatorHeight: CGFloat = 1.0
    static let textViewHeight: CGFloat = 70.0
}

/// All the constant values that will be used for animations will be contained here
enum Animation {
    static let duration: CGFloat = 0.35
}

/// Easy access values to control alpha properties for the UIElements in the app
enum Alpha {
    static let mid: CGFloat = 0.5
    static let solid: CGFloat = 1.0
    static let none: CGFloat = 0.0
    static let strongFade: CGFloat = 0.8
    static let weakFade: CGFloat = 0.3
}
