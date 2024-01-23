//
//  MovieView.swift
//  MovieRandomizer
//
//  Created by Ryan Johnson on 1/5/24.
//

import SwiftUI

struct MovieView: View {
    @EnvironmentObject var vc : MovieModelViewController
    var movie: MovieModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(movie.title)
                    .font(.system(size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                if movie.played {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                Text(String(movie.releaseYear))
            }
            if movie.animated {
                Text("Animated")
                    .fontWeight(.thin)
            }
            HStack {
                Text("ID: \(String(movie.id))")
                Spacer()
                Text("Index: \(String(vc.getMovieIndex(movie: movie)))")
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        MovieView(movie: MovieModel(id: 0, title: "A Movie", releaseYear: 1948, animated: true, played: true))
            .environmentObject(MovieModelViewController())
    }
}
