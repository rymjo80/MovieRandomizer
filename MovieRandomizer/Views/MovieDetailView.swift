//
//  MovieDetailView.swift
//  MovieRandomizer
//
//  Created by Ryan Johnson on 1/8/24.
//

import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var vc: MovieModelViewController
    @Environment(\.dismiss) var dismiss
    @State var movie: MovieModel
    @State var confirmationPresent = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("\(movie.title)")
                    .font(.system(size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text("\(String(movie.releaseYear))")
                    .font(.system(size: 18))
                if movie.animated {
                    Text("Animated")
                }
                
                if movie.played {
                    Button("Mark as unplayed.", role: .destructive) {
                        vc.markMovieAs(played: false, movie: movie)
                        movie = vc.getMovie(movie: movie)
                    }
                    .buttonStyle(.bordered)
                } else {
                    Button("Mark as played.") {
                        vc.markMovieAs(played: true, movie: movie)
                        movie = vc.getMovie(movie: movie)
                    }
                    .buttonStyle(.bordered)
                    
                }
            }
            .onAppear() {
                movie = vc.getMovie(movie: movie)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("\(Image(systemName: "trash"))", role: .destructive) {
                        confirmationPresent = true
                    }
                    .buttonStyle(.borderless)
                    .confirmationDialog("Are you sure?", isPresented: $confirmationPresent) {
                        Button("Delete \"\(movie.title)\" permanently", role: .destructive) {
                            vc.deleteMovie(movie: movie)
                        }
                    } message: {
                        Text("This cannot be undone.")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        EditMovieView(movie: movie)
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .padding(10)
                }
            }
        }
    }
}

#Preview {
    MovieDetailView(movie: MovieModel(id: 1, title: "Movie Title", releaseYear: 1997, animated: true, played: false))
        .environmentObject(MovieModelViewController())
}
