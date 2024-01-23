//
//  MovieListView.swift
//  MovieRandomizer
//
//  Created by Ryan Johnson on 1/4/24.
//

import SwiftUI

struct MovieListView: View {
    @EnvironmentObject var vc: MovieModelViewController
    @State private var show = "all"
    
    var body: some View {
        VStack {
            Spacer()
            Text("Movies")
                .font(.title)
            
            Picker(selection: $show, label: Text("Show")) {
                Text("All").tag("all")
                Text("Unplayed").tag("unplayed")
                Text("Played").tag("played")
                Text("Animated").tag("animated")
                Text("Live Action").tag("liveAction")
            }
            
            if show == "all" {
                showMovies(movies: vc.movies)
            } else if show == "played" {
                showMovies(movies: vc.playedMovies)
            } else if show == "unplayed" {
                showMovies(movies: vc.unplayedMovies)
            } else if show == "animated" {
                showMovies(movies: vc.animatedMovies)
            } else if show == "liveAction" {
                showMovies(movies: vc.liveActionMovies)
            }
        }
    }
}

#Preview {
    NavigationStack { 
        MovieListView()
            .environmentObject(MovieModelViewController())
    }
}

struct showMovies: View {
    @EnvironmentObject var vc: MovieModelViewController
    var movies: [MovieModel]
    var body: some View {
        List(movies, id: \.self) { movie in
            NavigationLink {
                MovieDetailView(movie: movie)
            } label: {
                MovieView(movie: movie)
            }
        }
        .listStyle(.plain)
        .onAppear {
//            vc.deleteFile(name: "MoviesData.json")
            vc.getMoviesFromFile()
        }
    }
}
