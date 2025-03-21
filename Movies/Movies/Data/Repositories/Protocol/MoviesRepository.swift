//
//  RemoteMoviesRepository.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//


import Combine
import Foundation

/// sourcery: AutoMockable
protocol MoviesRepository {
    func fetch(page: Int) -> AnyPublisher<MovieResponseDTO, MoviesAppError>
}
