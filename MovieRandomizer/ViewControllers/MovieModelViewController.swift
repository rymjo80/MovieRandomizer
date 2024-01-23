//
//  MoveModelViewController.swift
//  MovieRandomizer
//
//  Created by Ryan Johnson on 11/28/23.
//

import Foundation

class MovieModelViewController : ObservableObject {
    @Published var movies: [MovieModel]
    @Published var playedMovies: [MovieModel]
    @Published var unplayedMovies: [MovieModel]
    @Published var animatedMovies: [MovieModel]
    @Published var liveActionMovies: [MovieModel]
    private var editMovieId = 0
    private let manager: FileManager
    private let documents: URL
    
    init() {
        manager = FileManager.default
        documents = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        movies = [MovieModel]()
        playedMovies = [MovieModel]()
        unplayedMovies = [MovieModel]()
        animatedMovies = [MovieModel]()
        liveActionMovies = [MovieModel]()
        getMoviesFromFile()
    }
    
    var lastId: Int {
        get {
            getLastId()
        }
    }
    
    fileprivate func setMovieCollection(_ path: String) {
        if let data = manager.contents(atPath: path) {
            let decoder = JSONDecoder()
            if let movie = try? decoder.decode([MovieModel].self, from: data) {
                movies = movie.sorted(by: {$0.title < $1.title})
            }
        }
    }
    
    func getMoviesFromFile() {
        let path = getPath(fileName: "MoviesData.json")
        if manager.fileExists(atPath: path) {
            setMovieCollection(path)
        } else {
            let bundle = Bundle.main
            if let path = bundle.path(forResource: "MoviesData", ofType: "json") {
                setMovieCollection(path)
            }
        }
        updateMovieLists()
    }
    
    func getLastId() -> Int{
        let idOrder = movies.sorted(by: {$0.id < $1.id})
        if let last = idOrder.last {
            return last.id
        }
        return movies.count
    }
    
    func validateMovie(movie: MovieModel) -> [String] {
        var errors : [String] = []
        if movie.title == "" {
            errors.append("Title is required.")
        }
        if movie.releaseYear < 1927 || movie.releaseYear > Calendar.current.component(.year, from: Date()) {
            errors.append("The first motion picture was made in 1927. Please add the correct year.")
        }
        
        if (errors.isEmpty) {
            if movieExists(movie: movie) {
                updateMovie(movie: movie)
            } else {
                saveMovie(movie: movie)
            }
        }
        
        return errors
    }
    
    func movieExists(movie: MovieModel) -> Bool {
        var movieIdExists = false
        movies.forEach { movieInList in
            if movieInList.id == movie.id {
                movieIdExists = true
            }
        }
        return movieIdExists
    }
    
    func deleteMovie(movie: MovieModel) {
        let index = getMovieIndex(movie: movie)
        movies.remove(at: index)
        saveData(name: "MoviesData.json")
    }
    
    func saveMovie(movie: MovieModel) {
        movies.append(movie)
        saveData(name: "MoviesData.json")
    }
    
    func updateMovie(movie: MovieModel) {
        let index = getMovieIndex(movie: movie)
        if index > -1 {
            movies[index] = movie
            saveData(name: "MoviesData.json")
        }
    }
    
    func getMovieIndex(movie: MovieModel) -> Int {
        var index = -1
        for (i, movieInList) in movies.enumerated() {
            if movieInList.id == movie.id {
                index = i;
            }
        }
        return index
    }
    
    func getMovie(movie: MovieModel) -> MovieModel {
        let index = getMovieIndex(movie: movie)
        if index > -1 {
            return movies[index]
        }
        return movie
    }
    
    func saveData(name: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(movies) {
            manager.createFile(atPath: getPath(fileName: name), contents: data, attributes: nil)
        }
        updateMovieLists()
    }
    
    func deleteFile(name: String) {
        try? manager.removeItem(atPath: getPath(fileName: name))
    }
    
    func getPath(fileName: String) -> String {
        let fileURL = documents.appendingPathComponent(fileName)
        return fileURL.path
    }
    
    func updateMovieLists() {
        getPlayedMovies()
        getUnplayedMovies()
        getAnimatedMovies()
        getLiveActionMovies()
    }
    
    func getPlayedMovies() {
         playedMovies = movies.filter({ $0.played })
    }
    
    func getUnplayedMovies()  {
        unplayedMovies = movies.filter({ !$0.played })
    }
    
    func getAnimatedMovies() {
        animatedMovies = movies.filter({ $0.animated })
    }
    
    func getLiveActionMovies() {
        liveActionMovies = movies.filter( { !$0.animated })
    }
    
    func markMovieAs(played: Bool, movie: MovieModel) {
        let index = getMovieIndex(movie: movie)
        if index > -1 {
            movies[index].played = played
            saveData(name: "MoviesData.json")
        }
    }
    
    func getRandomMovie(by type: MovieType) -> MovieModel {
        switch type {
            case .all:
                if let movie = movies.randomElement() {
                    return movie
                }
            case .played:
                if let movie = playedMovies.randomElement() {
                    return movie
                }
            case .unplayed:
                if let movie = unplayedMovies.randomElement() {
                    return movie
                }
            case .animated:
                if let movie = animatedMovies.randomElement() {
                    return movie
                }
            case .liveAction:
                if let movie = liveActionMovies.randomElement() {
                    return movie
                }
        }
        return MovieModel(id: -1, title:"", releaseYear: 1926)
    }
}

enum MovieType : CaseIterable {
    case all, played, unplayed, animated, liveAction
}
