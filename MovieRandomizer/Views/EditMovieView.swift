//
//  EditMovieView.swift
//  MovieRandomizer
//
//  Created by Ryan Johnson on 1/5/24.
//

import SwiftUI

struct EditMovieView : View {
    @EnvironmentObject var vc: MovieModelViewController
    @Environment(\.dismiss) var dismiss
    @State private var title = String()
    @State private var year = Int()
    @State private var animated = Bool()
    @State private var played = Bool()
    @State private var newMovie = MovieModel(id: 0, title: "", releaseYear: 1926)
    @State private var errors = [String]()
    @State private var confirmationPresent = false
    var id: Int
   
    init(movie: MovieModel) {
        id = movie.id
        _title = .init(initialValue: movie.title)
        _year = .init(initialValue: movie.releaseYear)
        _animated = .init(initialValue: movie.animated)
        _played = .init(initialValue: movie.played)
    }
    var body : some View {
        VStack {
            Spacer()
            Text("Edit Movie")
                .font(.title)
            Form {
                Section {
                    HStack {
                        Text("Movie Title: ")
                            .font(.headline)
                        TextField("Required", text: $title)
                    }
                    HStack {
                        Text("Release Year: ")
                            .font(.headline)
                        TextField("Required", value: $year, formatter: NumberFormatter())
                    }
                    
                    Toggle(isOn: $animated, label: {
                        Text("Animated")
                            .font(.headline)
                    })
                }
                Section {
                    Button("Submit", action: {
                        newMovie = MovieModel(id: id, title: title, releaseYear: year, animated: animated, played: played)
                        errors = vc.validateMovie(movie: newMovie)
                        if errors.isEmpty {
                            dismiss()
                        }
                    })
                    .buttonStyle(.borderedProminent)
                }
                
                ForEach(errors, id: \.self) { error in
                    Text(error)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditMovieView(movie: MovieModel(id: 0, title: "Movie", releaseYear: 2023))
            .environmentObject(MovieModelViewController())
    }
}

