//
//  MoviesListViewModelImplTests.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//

import XCTest
import Combine

@testable import Movies

final class MoviesListViewModelImplTests: XCTestCase {
    
    // MARK: - Private Typealias
    
    private typealias SUT = MoviesListViewModelImpl
    
    // MARK: - Private Properties
    
    private var sut: SUT!
    private var mockFetchMoviesUseCase: FetchMoviesUseCaseMock!
    private var mockItemViewModelFactory: MovieItemViewModelFactoryMock!
    private var tasks: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        let mockMovies = [
            MovieModel(id: 1, name: "Movie 1", overview: "Overview", posterURL: nil, releaseDate: nil, genres: [])
        ]
        tasks = .init()
        mockFetchMoviesUseCase = FetchMoviesUseCaseMock()
        mockItemViewModelFactory = MovieItemViewModelFactoryMock()
        mockItemViewModelFactory.createFromModelMovieModelAnyMovieItemViewModelReturnValue = .init(MovieItemViewModelMock())
        mockFetchMoviesUseCase.executePageIntAnyPublisherMovieModelMoviesAppErrorReturnValue = Just(mockMovies)
            .setFailureType(to: MoviesAppError.self)
            .eraseToAnyPublisher()
        sut = SUT(fetchMoviesUseCase: mockFetchMoviesUseCase,
                                      itemViewModelFactory: mockItemViewModelFactory)
    }
    
    override func tearDown() {
        super.tearDown()

        sut = nil
        mockFetchMoviesUseCase = nil
        mockItemViewModelFactory = nil
        tasks = nil
    }
    
    // MARK: - Tests
    
    func test_init_shouldBeEmpty() {
        XCTAssertEqual(sut.state, .empty)
    }

    func test_loadItems_shouldSetEmptyState() {
        let expectation = XCTestExpectation(description: "State should be set to loading")
        
        sut.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .empty:
                    expectation.fulfill()
                default:
                    XCTFail("Expected state to be .hasContent with isLoading = true")
                }
            }
            .store(in: &tasks)
        
        sut.loadItems()
        
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func test_loadItems_success_shouldUpdateStateToHasContent() {
        let expectation = XCTestExpectation(description: "State should be updated to .hasContent")
        
        sut.$state
            .dropFirst(2)
            .sink { state in
                switch state {
                case .hasContent(let items, let isLoading):
                    XCTAssertFalse(isLoading)
                    XCTAssertEqual(items.count, 1)
                    expectation.fulfill()
                default:
                    XCTFail("Expected state to be .hasContent")
                }
            }
            .store(in: &tasks)
        
        sut.loadItems()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(mockFetchMoviesUseCase.executePageIntAnyPublisherMovieModelMoviesAppErrorReceivedPage, 1)
        XCTAssertEqual(mockFetchMoviesUseCase.executePageIntAnyPublisherMovieModelMoviesAppErrorCallsCount, 1)
        XCTAssertEqual(mockItemViewModelFactory.createFromModelMovieModelAnyMovieItemViewModelCallsCount, 1)
    }
    
    func test_loadItems_failure_shouldSetErrorState() {
        let expectation = XCTestExpectation(description: "State should be updated to .error")
        let error = MoviesAppError.networkError(NSError(domain: "test.error", code: -1))

        mockFetchMoviesUseCase.executePageIntAnyPublisherMovieModelMoviesAppErrorReturnValue = Fail<[MovieModel], MoviesAppError>(error: .networkError(error))
            .eraseToAnyPublisher()
        
        sut.$state
            .dropFirst(2)
            .sink { state in
                switch state {
                case .error:
                    expectation.fulfill()
                default:
                    XCTFail("Expected state to be .error")
                }
            }
            .store(in: &tasks)
        
        sut.loadItems()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(mockFetchMoviesUseCase.executePageIntAnyPublisherMovieModelMoviesAppErrorReceivedPage, 1)
        XCTAssertEqual(mockFetchMoviesUseCase.executePageIntAnyPublisherMovieModelMoviesAppErrorCallsCount, 1)
        XCTAssertEqual(mockItemViewModelFactory.createFromModelMovieModelAnyMovieItemViewModelCallsCount, 0)
    }
}
