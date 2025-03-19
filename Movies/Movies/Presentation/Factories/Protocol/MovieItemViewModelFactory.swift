//
//  MovieItemViewModelFactory 2.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//


import Foundation

/// sourcery: AutoMockable
protocol MovieItemViewModelFactory {
    func create(from model: MovieModel) -> any MovieItemViewModel
}
