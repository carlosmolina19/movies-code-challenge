//
//  MovieModelTests.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//

import Foundation
import XCTest

@testable import Movies

final class MovieModelTests: XCTestCase {

    // MARK: - Typealias

    private typealias SUT = MovieModel

    // MARK: - Private Properties

    private var sut: SUT!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Tests

    func test_init_valuesShouldBeEqual() {
        guard let posterURL = URL(string: "https://test.com") else {
            XCTFail("Init error: Invalid URL")
            return
        }
        let name = "foo.name"
        let overview = "foo.overview"
        let releaseDate = Date()
        let genres = [GenreModel(id: 1, name: "foo.genre")]
        
        sut = SUT(id: 111,
                  name: name,
                  overview: overview,
                  posterURL: posterURL,
                  releaseDate: releaseDate,
                  genres: genres)
        
        XCTAssertEqual(sut.id,111)
        XCTAssertEqual(sut.name, name)
        XCTAssertEqual(sut.overview, overview)
        XCTAssertEqual(sut.posterURL?.absoluteString, posterURL.absoluteString)
        XCTAssertEqual(sut.releaseDate, releaseDate)
        XCTAssertTrue(!sut.genres.isEmpty)
    }
}
