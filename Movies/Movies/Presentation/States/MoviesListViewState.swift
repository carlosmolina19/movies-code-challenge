//
//  MoviesViewState.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//


import Foundation

enum MoviesListViewState {
    case empty
    case loading
    case hasContent([any MovieItemViewModel], isLoading: Bool)
    case error(String)
}

extension MoviesListViewState: Equatable {
    static func == (lhs: MoviesListViewState, rhs: MoviesListViewState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case let (.hasContent(lhsItems, lhsLoading), .hasContent(rhsItems, rhsLoading)):
            return lhsItems.map { $0.id } == rhsItems.map { $0.id } && lhsLoading == rhsLoading
        case let (.error(lhsMessage), .error(rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
