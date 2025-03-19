//
//  GenreModelTests.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//

import Foundation
import XCTest

@testable import Movies

final class GenreModelTests: XCTestCase {

    // MARK: - Typealias

    private typealias SUT = GenreModel

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
        let name = "foo.name"
        
        sut = SUT(id: 111, name: name)
        
        XCTAssertEqual(sut.id,111)
        XCTAssertEqual(sut.name, name)
    }
}
