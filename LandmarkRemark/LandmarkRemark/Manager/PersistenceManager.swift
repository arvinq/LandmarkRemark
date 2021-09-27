//
//  PersistenceManager.swift
//  LandmarkRemark
//
//  Created by Arvin Quiliza on 9/21/21.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class PersistenceManager {
    
    // single instance for the whole application
    static let shared = PersistenceManager()
    private init () { }
    
    // reference used to access our FirestoreDB
    private let db = Firestore.firestore()
    
    /**
     * Access DB and adds a listener to snapshot get events. Passes a Result object to properly handle success and failure states.
     * We are retrieving a type and using a decoder to decode the object  instead of processing the actual objects so that values are
     * not tightly coupled whenever our data has changed.
     */
    func getRemarks(completion: @escaping (Result<[Remark], LRError>) -> Void) {
        // query snapshot holds the documents from our collection
        db.collection("remarks").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // each document snapshot represents one document
            let remarks = documents.compactMap { queryDocSnapshot -> Remark? in
                return try? queryDocSnapshot.data(as: Remark.self)
            }
            
            completion(.success(remarks))
        }
    }
    
    /**
     * Encoding a passed Remark and saving it into the Firestore database.
     */
    func addRemark(remark: Remark, completion: @escaping (LRError?) -> Void) {
        do {
            let _ = try db.collection("remarks").addDocument(from: remark)
            completion(nil)
        } catch {
            completion(.unableToComplete)
        }
        
    }
}
