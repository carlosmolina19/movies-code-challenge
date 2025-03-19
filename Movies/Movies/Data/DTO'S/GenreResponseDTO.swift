//
//  GenreResponseDTO.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//


import Foundation

struct GenreResponseDTO: Codable {
    let genres: [GenreDTO]
}

struct GenreDTO: Codable {
    let id: Int
    let name: String
}
