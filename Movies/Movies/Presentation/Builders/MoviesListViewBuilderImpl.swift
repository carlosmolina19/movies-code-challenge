//
//  MoviesListViewBuilderImpl.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//


import Foundation
import SwiftUI

struct MoviesListViewBuilderImpl {
    func build() -> some View {
        let networkProvider = NetworkProviderImpl(session: .shared)
        
        let movieRepository = RemoteMoviesRepositoryImpl(networkProvider: networkProvider)
        let genreRepository = RemoteGenresRepositoryImpl(networkProvider: networkProvider)
        
        let fetchMoviesUseCase = FetchMoviesUseCaseImpl(
            movieRepository: movieRepository,
            genreRepository: genreRepository
        )
        
        let itemViewModelFactory = MovieItemViewModelFactoryImpl(locale: .current)
        
        let viewModel = MoviesListViewModelImpl(
            fetchMoviesUseCase: fetchMoviesUseCase,
            itemViewModelFactory: itemViewModelFactory
        )
        
        return MoviesListView(viewModel: viewModel)
    }
}
