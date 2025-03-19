//
//  MockMovieItemViewModel.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//


import Foundation
import Combine

struct MockMovieItemViewModel: MovieItemViewModel {
    var id: String
    var name: String
    var url: URL?
    var genres: [String]
    var overview: String
    var date: String
    
    init(
        id: String = UUID().uuidString,
        name: String = "Sample Movie",
        url: URL? = URL(string: "https://example.com/poster.jpg"),
        genres: [String] = ["Action", "Sci-Fi"],
        overview: String = "This is a sample overview of the movie.",
        date: String = "March 19, 2025"
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.genres = genres
        self.overview = overview
        self.date = date
    }
}
