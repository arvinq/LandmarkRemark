//
//  RemarkViewModel.swift
//  LandmarkRemark
//
//  Created by Arvin on 25/9/21.
//

import Foundation
import CoreLocation
import MapKit

struct RemarkViewModel: Hashable {
    var title: String
    var note: String
    var latitude: Double
    var longitude: Double
    
    /// Computed property to represent coordinate coming from the RemarkViewModel's latitude and longitude
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude),
                                          longitude: CLLocationDegrees(self.longitude))
        }
        
        set {
            self.latitude = newValue.latitude
            self.longitude = newValue.longitude
        }
    }
    
    /// Override memberwise initializer for populating Remark properties
    init(title: String, note: String, latitude: Double, longitude: Double) {
        self.title = title
        self.note = note
        self.longitude = longitude
        self.latitude = latitude
    }
    
    /// Iniitalize Remark View Model by using Remark model
    init(remark: Remark) {
        self.init(title: remark.title, note: remark.note, latitude: remark.latitude, longitude: remark.longitude)
    }
    
    /// Initialize Remark View Model same with member wise inits but with the use of coordinates instead of the lat and long values
    init(title: String, note: String, coordinate: CLLocationCoordinate2D) {
        self.init(title: title, note: note, latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
