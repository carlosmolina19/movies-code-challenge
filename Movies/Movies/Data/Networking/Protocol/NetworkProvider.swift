//
//  NetworkProvider.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 17/03/25.
//


import Combine
import Foundation

protocol NetworkProvider {
    func fetch(from url: URL) -> AnyPublisher<Data, Error>
}