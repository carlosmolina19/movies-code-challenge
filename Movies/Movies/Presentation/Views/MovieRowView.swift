//
//  MovieRowView.swift
//  Movies
//
//  Created by Carlos Molina Sáenz on 19/03/25.
//

import NukeUI
import SwiftUI

struct MovieRowView: View {
    let movie: any MovieItemViewModel
    
    var body: some View {
        HStack {
            LazyImage(url: movie.url) { state in
                if let image = state.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else if state.error != nil {
                    Color.gray
                } else {
                    ProgressView()
                }
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(movie.name)
                    .font(.headline)
                Text(movie.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(movie.overview)
                    .font(.footnote)
                    .lineLimit(2)
            }
            .padding(.leading, 8)
        }
    }
}
