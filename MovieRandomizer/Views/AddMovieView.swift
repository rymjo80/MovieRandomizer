//
//  AddMovieView.swift
//  MovieRandomizer
//
//  Created by Ryan Johnson on 11/28/23.
//

import SwiftUI

struct AddMovieView : View {
    @EnvironmentObject var vc: MovieModelViewController
    @Environment(\.dismiss) var dismiss
    @State private var title = String()
    @State private var year = 1926
    @State private var animated = Bool()
    private var played = false
    @State private var newMovie = MovieModel(id: 0, title: "", releaseYear: 1926)
    @State private var errors = [String]()

    var body : some View {
        VStack {
            Spacer()
            Text("Add A Movie")
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
                    HStack {
                        Button("Submit", action: {
                            newMovie = MovieModel(id: (vc.lastId + 1), title: title, releaseYear: year, animated: animated, played: played)
                            errors = vc.validateMovie(movie: newMovie)
                            if errors.isEmpty {
                                dismiss()
                            }
                        })
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Button("Clear", role: .destructive, action: {
                            title = ""
                            year = 1926
                            animated = false
                            errors = []
                            dismiss()
                        })
                        .buttonStyle(.bordered)
                    }
                    
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
    AddMovieView()
        .environmentObject(MovieModelViewController())
}
