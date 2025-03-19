//
//  MovieItemViewModelFactoryImpl.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//

import Foundation

final class MovieItemViewModelFactoryImpl: MovieItemViewModelFactory {
    
    // MARK: - Private Properties
    
    private let locale: Locale
    
    // MARK: - Initialization

    init(locale: Locale) {
        self.locale = locale
    }
    
    // MARK: - Internal Methods

    func create(from model: MovieModel) -> any MovieItemViewModel {
        MovieItemViewModelImpl(model: model, locale: locale)
    }
}
