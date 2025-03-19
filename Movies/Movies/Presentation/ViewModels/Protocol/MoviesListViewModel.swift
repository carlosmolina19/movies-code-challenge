//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//


import Foundation

/// sourcery: AutoMockable
protocol MoviesListViewModel: ObservableObject {
    var state: MoviesListViewState { get }
    
    func loadItems()
}
