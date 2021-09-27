//
//  Remark.swift
//  LandmarkRemark
//
//  Created by Arvin Quiliza on 9/21/21.
//

import Foundation
import FirebaseFirestoreSwift

/**
 * Remark model is mainly used for representing objects retrieved from Firestore DB
 */
struct Remark: Codable {
    // map the document's ID to our id here in our model
    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var note: String
    var latitude: Double
    var longitude: Double
}
