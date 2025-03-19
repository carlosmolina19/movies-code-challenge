//
//  MovieItemViewModelImpl.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//


import Foundation

final class MovieItemViewModelImpl: MovieItemViewModel {
    
    // MARK: - Internal Computed Properties
    
    var id: String {
        "\(model.id)"
    }
    
    var name: String {
        model.name
    }
    
    var url: URL? {
        model.posterURL
    }
    
    var genres: [String] {
        model.genres.map {
            $0.name
        }
    }
    
    var overview: String {
        model.overview
    }
    
    var date: String {
        guard
            let releaseDate = model.releaseDate
        else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.locale = locale

        return dateFormatter.string(from: releaseDate)
    }

    // MARK: - Private Properties
    
    private let model: MovieModel
    private let locale: Locale

    // MARK: - Initialization

    init(model: MovieModel, locale: Locale) {
        self.model = model
        self.locale = locale
    }
}
