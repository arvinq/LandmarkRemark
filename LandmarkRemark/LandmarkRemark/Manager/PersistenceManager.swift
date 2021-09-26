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
    
    private let db = Firestore.firestore()
    
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
    
    func addRemark(remark: Remark, completion: @escaping (LRError?) -> Void) {
        do {
            let _ = try db.collection("remarks").addDocument(from: remark)
            completion(nil)
        } catch {
            completion(.unableToComplete)
        }
        
    }
}
