//
//  FetchMoviesUseCaseTests.swift
//  MoviesTests
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//

import Combine
import XCTest
@testable import Movies

final class FetchMoviesUseCaseImplTests: XCTestCase {
    
    // MARK: - Private Typealias
    
    private typealias SUT = FetchMoviesUseCaseImpl
    
    // MARK: - Private Properties
    
    private var sut: SUT!
    private var mockMoviesRepository: MoviesRepositoryMock!
    private var mockGenresRepository: GenresRepositoryMock!
    private var tasks: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        tasks = .init()
        mockMoviesRepository = MoviesRepositoryMock()
        mockGenresRepository = GenresRepositoryMock()
        
        sut = SUT(movieRepository: mockMoviesRepository,
                  genreRepository: mockGenresRepository)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockMoviesRepository = nil
        mockGenresRepository = nil
        tasks = nil
    }
    
    // MARK: - Tests
    
    func test_execute_shouldReturnMoviesWithGenres() throws {
        guard let asset = NSDataAsset(name: "MoviesListResponse"),
              let genreAsset = NSDataAsset(name: "GenresListResponse")
        else {
            XCTFail("Init Error")
            return
        }
        
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
        
        let movieResponse = try decode.decode(MovieResponseDTO.self,
                                              from: asset.data)
        let genreResponse = try decode.decode(GenreResponseDTO.self,
                                              from: genreAsset.data)
        
        let moviesPublisher = Just(movieResponse)
            .setFailureType(to: MoviesAppError.self)
            .eraseToAnyPublisher()
        let genrePublisher = Just(genreResponse)
            .setFailureType(to: MoviesAppError.self)
            .eraseToAnyPublisher()
        
        mockMoviesRepository.fetchPageIntAnyPublisherMovieResponseDTOMoviesAppErrorReturnValue = moviesPublisher
        mockGenresRepository.fetchAnyPublisherGenreResponseDTOMoviesAppErrorReturnValue = genrePublisher
        
        let expectation = XCTestExpectation(
            description: "test_execute_shouldReturnMoviesWithGenres")
        
        sut.execute(page: 2)
            .sink {
                switch $0 {
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { list in
                XCTAssertEqual(list.count, 3)
            }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(mockMoviesRepository.fetchPageIntAnyPublisherMovieResponseDTOMoviesAppErrorReceivedPage, 2)
        XCTAssertEqual(mockMoviesRepository.fetchPageIntAnyPublisherMovieResponseDTOMoviesAppErrorCallsCount, 1)
        XCTAssertEqual(mockGenresRepository.fetchAnyPublisherGenreResponseDTOMoviesAppErrorCallsCount, 1)
    }
    
    func test_execute_whenMoviesRepositoryFails_shouldReturnError() throws {
        guard let asset = NSDataAsset(name: "GenresListResponse")
        else {
            XCTFail("Init Error")
            return
        }
        
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
        let genreResponse = try decode.decode(GenreResponseDTO.self,
                                              from: asset.data)
        let genrePublisher = Just(genreResponse)
            .setFailureType(to: MoviesAppError.self)
            .eraseToAnyPublisher()
        
        let errorMovies = MoviesAppError.networkError(NSError(domain: "test.error", code: -1))
        let moviesPublisher = Fail<MovieResponseDTO, MoviesAppError>(error: errorMovies).eraseToAnyPublisher()
        
        mockMoviesRepository.fetchPageIntAnyPublisherMovieResponseDTOMoviesAppErrorReturnValue = moviesPublisher
        mockGenresRepository.fetchAnyPublisherGenreResponseDTOMoviesAppErrorReturnValue = genrePublisher

        let expectation = XCTestExpectation(description: "Fetch movies fails")
        
        sut.execute(page: 1)
            .sink {
                switch $0 {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, errorMovies.localizedDescription)
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { list in
                XCTFail("Movies should not have been fetched")
            }.store(in: &tasks)
                   
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(mockMoviesRepository.fetchPageIntAnyPublisherMovieResponseDTOMoviesAppErrorReceivedPage, 1)
        XCTAssertEqual(mockMoviesRepository.fetchPageIntAnyPublisherMovieResponseDTOMoviesAppErrorCallsCount, 1)
        XCTAssertEqual(mockGenresRepository.fetchAnyPublisherGenreResponseDTOMoviesAppErrorCallsCount, 1)
    }
    
    func test_execute_whenGenresRepositoryFails_shouldReturnMoviesWithEmptyGenres() throws {
        guard let asset = NSDataAsset(name: "MoviesListResponse")
        else {
            XCTFail("Init Error")
            return
        }
        
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
        let movieResponse = try decode.decode(MovieResponseDTO.self,
                                              from: asset.data)
        let moviesPublisher = Just(movieResponse)
            .setFailureType(to: MoviesAppError.self)
            .eraseToAnyPublisher()
        let error = MoviesAppError.networkError(NSError(domain: "test.error", code: -1))
        let genresErrorPublisher = Fail<GenreResponseDTO, MoviesAppError>(error: error).eraseToAnyPublisher()

        mockMoviesRepository.fetchPageIntAnyPublisherMovieResponseDTOMoviesAppErrorReturnValue = moviesPublisher
        mockGenresRepository.fetchAnyPublisherGenreResponseDTOMoviesAppErrorReturnValue = genresErrorPublisher

        
        let expectation = XCTestExpectation(description: "Fetch movies but genres fail")
        
        sut.execute(page: 1)
            .sink {
                switch $0 {
                case .failure(_):
                    XCTFail("Movies should have been fetched even if genres fail")
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { list in
                XCTAssertEqual(list.count, 3)
                XCTAssertEqual(list.first?.genres.count, 0)
            }.store(in: &tasks)

        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(mockMoviesRepository.fetchPageIntAnyPublisherMovieResponseDTOMoviesAppErrorReceivedPage, 1)
        XCTAssertEqual(mockMoviesRepository.fetchPageIntAnyPublisherMovieResponseDTOMoviesAppErrorCallsCount, 1)
        XCTAssertEqual(mockGenresRepository.fetchAnyPublisherGenreResponseDTOMoviesAppErrorCallsCount, 1)
    }
}
