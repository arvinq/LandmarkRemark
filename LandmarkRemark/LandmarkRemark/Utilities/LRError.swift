//
//  LRError.swift
//  LandmarkRemark
//
//  Created by Arvin on 25/9/21.
//

import Foundation

/// LandmarkRemark error containing messages used for specific issue encountered in the system
enum LRError: String, Error {
    case unableToComplete         = "Unable to complete your request. Please check your network connection."
    case invalidData              = "The data received from the server is invalid. Please try again."
    case emptyResponse            = "No response is returned."
    case invalidResponse          = "Invalid response from the server. Please try again."
    case locationServicesDisabled = "Your device's location services is disabled. Map is not available if location services is off. Please turn it on in your device's Settings > Privacy to use this application's features."
    case locationAuthOff          = "Please turn on location access request authorization to properly use the features of this application."
    case locationAuthRestricted   = "The location services are restricted for this application."
}
