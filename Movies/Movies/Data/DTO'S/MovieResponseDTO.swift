//
//  MovieDTO.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//

import Foundation

struct MovieResponseDTO: Codable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int
}

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let genreIds: [Int]
    let adult: Bool
    let video: Bool
}
