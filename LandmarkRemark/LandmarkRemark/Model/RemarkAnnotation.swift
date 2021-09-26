//
//  RemarkAnnotation.swift
//  LandmarkRemark
//
//  Created by Arvin on 26/9/21.
//

import UIKit
import MapKit

class RemarkAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}
