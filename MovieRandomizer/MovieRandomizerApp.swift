//
//  MovieRandomizerApp.swift
//  MovieRandomizer
//
//  Created by Ryan Johnson on 11/28/23.
//

import SwiftUI

@main
struct MovieRandomizerApp: App {
    @StateObject private var vc = MovieModelViewController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vc)
        }
    }
}
