//
//  RemoteGenresRepositoryImpl.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//

import Combine
import Foundation

final class RemoteGenresRepositoryImpl: GenresRepository {

    // MARK: - Private Properties

    private let networkProvider: NetworkProvider

    // MARK: - Initialization

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    // MARK: - Internal Methods

    func fetch() -> AnyPublisher<GenreResponseDTO, MoviesAppError> {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "MOVIE_API_VERSION") as? String ?? ""
        var components = URLComponents()
        components.scheme = Bundle.main.object(forInfoDictionaryKey: "MOVIE_API_SCHEME") as? String ?? ""
        components.host = Bundle.main.object(forInfoDictionaryKey: "MOVIE_API_HOST") as? String ?? ""
        components.path = "/\(version)/genre/movie/list"
        components.queryItems = [
            URLQueryItem(name: "language", value: "en-US")
        ]


        guard let url = components.url
        else {
            fatalError("Can't initialize URL")
        }
        
        return networkProvider.fetch(from: url).tryMap {
            let decode = JSONDecoder()
            decode.keyDecodingStrategy = .convertFromSnakeCase
            guard let response: GenreResponseDTO = try? decode.decode(GenreResponseDTO.self, from: $0)
            else {
                throw MoviesAppError.invalidFormat
            }
            return response
        }.mapError {
            guard let error = $0 as? MoviesAppError
            else {
                return MoviesAppError.networkError($0)
            }
            return error
        }
        .eraseToAnyPublisher()
    }
}
