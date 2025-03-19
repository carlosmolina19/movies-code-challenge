//
//  FetchMoviesUseCase.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//

import Foundation
import Combine

final class FetchMoviesUseCaseImpl: FetchMoviesUseCase {
    
    // MARK: - Private Properties

    private let movieRepository: MoviesRepository
    private let genreRepository: GenresRepository

    // MARK: - Initialization

    init(movieRepository: MoviesRepository, genreRepository: GenresRepository) {
        self.movieRepository = movieRepository
        self.genreRepository = genreRepository
    }

    // MARK: - Internal Methods

    func execute(page: Int) -> AnyPublisher<[MovieModel], MoviesAppError> {
        let moviesPublisher = movieRepository.fetch(page: page)
        let genresPublisher = genreRepository.fetch()
            .catch { _ in
                Just(GenreResponseDTO(genres: []))
                .setFailureType(to: MoviesAppError.self)
            }
            .eraseToAnyPublisher()

        return Publishers.CombineLatest(moviesPublisher, genresPublisher)
            .map { moviesDTO, genreResponseDTO in
                let genresDictionary = Dictionary(uniqueKeysWithValues: genreResponseDTO.genres.map { ($0.id, $0) })
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                return moviesDTO.results.map {
                    MovieModel(
                        id: $0.id,
                        name: $0.title,
                        overview: $0.overview,
                        posterURL: URL(string: $0.posterPath ?? ""),
                        releaseDate: formatter.date(from: $0.releaseDate),
                        genres: $0.genreIds.compactMap {
                            guard
                                let genreDTO = genresDictionary[$0]
                            else { return nil }
                            
                            return GenreModel(id: genreDTO.id, name: genreDTO.name)
                        }
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
