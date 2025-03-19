//
//  MovieItemViewModelImplTests.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//

import Foundation
import XCTest

@testable import Movies

final class MovieItemViewModelImplTests: XCTestCase {

    // MARK: - Typealias

    private typealias SUT = MovieItemViewModelImpl

    // MARK: - Private Properties

    private var sut: SUT!
    private var locale: Locale!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        
        locale = Locale(identifier: "en_US")
    }

    override func tearDown() {
        super.tearDown()
        
        sut = nil
        locale = nil
    }

    // MARK: - Tests

    func test_init_shouldReturnValues() throws {
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let posterURL = URL(string: "https://test.com"),
        let releaseDate = dateFormatter.date(from: "2025-03-18")
        else {
            XCTFail("Init error: Invalid URL")
            return
        }
        let mockMovies = MovieModel(id: 1, name: "foo.name", overview: "foo.overview", posterURL: posterURL, releaseDate: releaseDate, genres: [GenreModel(id: 1, name: "foo.genre.name")])
        
        sut = SUT(model: mockMovies, locale: locale)

        XCTAssertEqual(sut.id, "\(mockMovies.id)")
        XCTAssertEqual(sut.name, mockMovies.name)
        XCTAssertEqual(sut.overview, mockMovies.overview)
        XCTAssertEqual(sut.url?.absoluteString, mockMovies.posterURL?.absoluteString)
        XCTAssertEqual(sut.date, "March 18, 2025")
        XCTAssertEqual(sut.genres.first, "foo.genre.name")

    }
}
