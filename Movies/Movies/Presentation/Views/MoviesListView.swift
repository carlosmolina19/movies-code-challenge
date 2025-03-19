//
//  MoviesListView.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//

import SwiftUI

struct MoviesListView<T: MoviesListViewModel>: View {
    
    // MARK: - Private Properties
    
    @StateObject private var viewModel: T
    
    // MARK: - Initialization
    
    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Internal Properties
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Popular Movies")
                .onAppear {
                    viewModel.loadItems()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .empty:
            emptyView
        case .loading:
            ProgressView()
        case .error(let message):
            errorView(message)
        case .hasContent(let movies, let isLoading):
            listView(movies, isLoading: isLoading)
        }
    }
    
    private var emptyView: some View {
        VStack {
            Image(systemName: "film")
                .resizable()
                .frame(width: 80, height: 80)
                .padding()
                .foregroundColor(.gray)
            Text("No movies available")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()

            Button(action: {
                viewModel.loadItems()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
                .padding()
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
                .padding()

            Button(action: {
                viewModel.loadItems()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }
    
    private func listView(_ movies: [any MovieItemViewModel], isLoading: Bool) -> some View {
        List {
            ForEach(movies.indices, id: \.self) { index in
                MovieRowView(movie: movies[index])
                    .onAppear {
                        if index == movies.count - 1 && !isLoading {
                            viewModel.loadItems()
                        }
                    }
            }
        }
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MoviesListView(viewModel: MockMoviesListViewModel(state: .loading))
                .previewDisplayName("Loading")
            
            MoviesListView(viewModel: MockMoviesListViewModel(state: .empty))
                .previewDisplayName("Empty")
            
            MoviesListView(viewModel: MockMoviesListViewModel())
                .previewDisplayName("Content")
            
            MoviesListView(viewModel: MockMoviesListViewModel(state: .error("Network Error")))
                .previewDisplayName("Error")
            
        }
    }
}
