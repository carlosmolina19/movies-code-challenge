//
//  MoviesAppError.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//


import Foundation

enum MoviesAppError: Error {
    case invalidFormat
    case deallocated
    case networkError(Error)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidFormat:
            return "The received data format is invalid."
        case .deallocated:
            return "An unexpected deallocation occurred."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
