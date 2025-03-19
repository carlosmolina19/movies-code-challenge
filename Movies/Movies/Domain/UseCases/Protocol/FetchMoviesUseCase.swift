//
//  FetchMoviesUseCase.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//

import Combine
import Foundation

/// sourcery: AutoMockable
protocol FetchMoviesUseCase {
    func execute(page: Int) -> AnyPublisher<[MovieModel], MoviesAppError>
}
