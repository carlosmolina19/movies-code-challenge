//
//  MovieItemViewModel.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//


import Foundation

/// sourcery: AutoMockable
protocol MovieItemViewModel: Identifiable {
    var id: String { get}
    var name: String { get }
    var url: URL? { get }
    var genres: [String] { get }
    var overview: String { get }
    var date: String { get }
}
