//
//  RandomMovieView.swift
//  MovieRandomizer
//
//  Created by Ryan Johnson on 1/4/24.
//

import SwiftUI

struct RandomMovieView: View {
    @EnvironmentObject var vc: MovieModelViewController
    @State var selection = MovieType.unplayed
    @State var randomMovie: MovieModel = MovieModel(id: -1, title: "", releaseYear: 0)
    
    var body: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 10)
            Text("Random Movie")
                .font(.title)
            HStack {
                Text("from ")
                Picker(selection: $selection, label: Text("")) {
                    Text("All").tag(MovieType.all)
                    Text("Played").tag(MovieType.played)
                    Text("Unplayed").tag(MovieType.unplayed)
                }
                .onChange(of: selection, {
                    randomMovie = MovieModel(id: -1, title: "", releaseYear: 0)
                })
                .frame(width: 115)
                
                Text("Movies")
            }
            Button("Generate") {
                randomMovie = vc.getRandomMovie(by: selection)
            }
            .buttonStyle(.borderedProminent)
            
            if (randomMovie.title != "" && randomMovie.id != 0) {
                MovieView(movie: randomMovie)
                    .padding(EdgeInsets(top: 50, leading: 20, bottom: 40, trailing: 20))
                
                if !randomMovie.played {
                    Button("Mark Movie as Played") {
                        vc.markMovieAs(played: true, movie: randomMovie)
                        randomMovie = vc.getMovie(movie: randomMovie)
                    }
                    .buttonStyle(.bordered)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    RandomMovieView()
        .environmentObject(MovieModelViewController())
}
