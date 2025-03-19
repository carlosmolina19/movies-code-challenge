//
//  RemoteGenresRepositoryImplTests.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 18/03/25.
//

import Combine
import Foundation
import XCTest

@testable import Movies

final class RemoteGenresRepositoryImplTests: XCTestCase {
    
    // MARK: - Private Typealias
    
    private typealias SUT = RemoteGenresRepositoryImpl
    
    // MARK: - Private Properties
    
    private var sut: SUT!
    private var mockNetworkProvider: NetworkProviderMock!
    private var tasks: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        tasks = .init()
        mockNetworkProvider = NetworkProviderMock()
        sut = SUT(networkProvider: mockNetworkProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockNetworkProvider = nil
        tasks = nil
        
    }
    
    // MARK: - Tests
    
    func test_fetch_shouldReturnValues() {
        guard let asset = NSDataAsset(name: "GenresListResponse")
        else {
            XCTFail("Init Error")
            return
        }
        
        let expectation = XCTestExpectation(
            description: "test_fetch_shouldReturnValues")
        let publisher = Just(asset.data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        mockNetworkProvider.fetchFromUrlURLAnyPublisherDataErrorReturnValue = publisher
        
        sut.fetch().sink {
            switch $0 {
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: {
            XCTAssertNotNil($0)
            XCTAssertEqual($0.genres.count, 3)
        }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetworkProvider.fetchFromUrlURLAnyPublisherDataErrorCallsCount, 1)
        
        tasks.removeAll()
    }
    
    func test_fetch_whenErrorIsReceived_errorShouldNotBeNil() {
        let expectation = XCTestExpectation(
            description: "test_fetch_whenErrorIsReceived_errorShouldNotBeNil")
        let publisher = Fail<Data, Error>(error: NSError(domain: "test.domain",
                                                         code: -1))
            .eraseToAnyPublisher()
        
        mockNetworkProvider.fetchFromUrlURLAnyPublisherDataErrorReturnValue = publisher

        sut.fetch().sink {
            switch $0 {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { _ in
            XCTFail("Error was sent")
        }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(mockNetworkProvider.fetchFromUrlURLAnyPublisherDataErrorCallsCount, 1)
        tasks.removeAll()
    }
    
    func test_fetch_whenBadDataIsReceived_errorShouldNotBeNil() {
        guard let data = "bad data".data(using: .utf8)
        else {
            XCTFail("Init Error")
            return
        }
        
        let expectation = XCTestExpectation(
            description: "test_fetch_whenBadDataIsReceived_shouldNotBeNil")
        let publisher = Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        mockNetworkProvider.fetchFromUrlURLAnyPublisherDataErrorReturnValue = publisher

        sut.fetch().sink {
            switch $0 {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { _ in
            XCTFail("Bad Data was sent")
        }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetworkProvider.fetchFromUrlURLAnyPublisherDataErrorCallsCount, 1)
        tasks.removeAll()
    }
}
