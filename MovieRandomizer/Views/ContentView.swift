//
//  ContentView.swift
//  MovieRandomizer
//
//  Created by Ryan Johnson on 11/28/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vc: MovieModelViewController
   
    var body: some View {
        TabView{
            NavigationStack {
                MovieListView()
            }
            .tabItem {
                Label("Movie List", systemImage: "list.bullet.circle")
            }
            .tag("movieList")
            
            AddMovieView()
                .tabItem {
                    Label("Add Movie", systemImage: "plus")
                }
                .tag("addMovie")
            
            RandomMovieView()
                .tabItem {
                    Label("Random Movie", systemImage: "movieclapper")
                }
                .tag("randomMovie")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MovieModelViewController())
}
