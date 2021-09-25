//
//  LRError.swift
//  LandmarkRemark
//
//  Created by Arvin on 25/9/21.
//

import Foundation

/// LandmarkRemark error containing messages used for specific issue encountered in the system
enum LRError: String, Error {
    case unableToComplete = "Unable to complete your request. Please check your network connection."
    case invalidData      = "The data received from the server is invalid. Please try again."
    case emptyResponse    = "No response is returned."
}
