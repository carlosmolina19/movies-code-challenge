//
//  MockMoviesListViewModel.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//


import Foundation
import Combine

final class MockMoviesListViewModel: MoviesListViewModel {
    @Published var state: MoviesListViewState
    
    init(state: MoviesListViewState = .hasContent([
        MockMovieItemViewModel(),
        MockMovieItemViewModel()
    ], isLoading: false)) {
        self.state = state
    }
    
    func loadItems() {}
}
