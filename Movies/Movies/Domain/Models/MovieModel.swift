//
//  MovieModel.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//


import Foundation

struct MovieModel: Identifiable {
    let id: Int
    let name: String
    let overview: String
    let posterURL: URL?
    let releaseDate: Date?
    let genres: [GenreModel]
}
