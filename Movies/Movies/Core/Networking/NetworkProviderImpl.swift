//
//  NetworkProviderImpl.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 17/03/25.
//

import Combine
import Foundation

final class NetworkProviderImpl: NetworkProvider {
    
    // MARK: - Private Properties
    
    private let session: URLSession
    
    // MARK: - Initialization
    
    init(session: URLSession) {
        self.session = session
    }
    
    // MARK: - Internal Methods
    
    func fetch(from url: URL) -> AnyPublisher<Data, Error> {
        let auth: String = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: request)
            .retry(3)
            .mapError { $0 as Error }
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
