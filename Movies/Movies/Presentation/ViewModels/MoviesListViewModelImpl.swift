//
//  MoviesListViewModelImpl.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//


import Combine
import Foundation

final class MoviesListViewModelImpl: MoviesListViewModel {
    
    // MARK: - Internal Properties
    
    @Published var state: MoviesListViewState = .empty
    
    // MARK: - Private Properties
    
    private var fetchMoviesUseCase: FetchMoviesUseCase
    private var itemViewModelFactory: MovieItemViewModelFactory
    private var tasks = Set<AnyCancellable>()
    private var items = [any MovieItemViewModel]()
    private var page = 1
    
    // MARK: - Initialization
    
    init(fetchMoviesUseCase: FetchMoviesUseCase,
         itemViewModelFactory: MovieItemViewModelFactory) {
        
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.itemViewModelFactory = itemViewModelFactory
    }
    
    // MARK: - Internal Methods
    
    func loadItems() {
        state =  items.isEmpty ? .empty : .hasContent(items,
                                                      isLoading: true)
        fetchMoviesUseCase.execute(page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.state = items.isEmpty ? .error(error.localizedDescription) : .hasContent(items,
                                                                                                  isLoading: false)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] moviesList in
                guard let self = self else { return }
                items.append(contentsOf: moviesList.map {
                    self.itemViewModelFactory.create(from: $0)
                })
                self.state = .hasContent(self.items, isLoading: false)
            })
            .store(in: &tasks)
    }
}
