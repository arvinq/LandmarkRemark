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
    
    init(title: String, note: String, latitude: Double, longitude: Double) {
        self.title = title
        self.note = note
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(remark: Remark) {
        self.init(title: remark.title, note: remark.note, latitude: remark.latitude, longitude: remark.longitude)
    }
    
    init(title: String, note: String, coordinate: CLLocationCoordinate2D) {
        self.init(title: title, note: note, latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
