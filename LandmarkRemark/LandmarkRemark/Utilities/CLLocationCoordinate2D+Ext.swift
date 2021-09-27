//
//  CLLocationCoordinate2D+Ext.swift
//  LandmarkRemark
//
//  Created by Arvin on 25/9/21.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    /**
     * Making CLLocationCoordinate conform to equatable and compare two CLLocation values in the application
     */
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
