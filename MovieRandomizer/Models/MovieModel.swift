//
//  MovieModel.swift
//  MovieRandomizer
//
//  Created by Ryan Johnson on 11/28/23.
//

import Foundation

struct MovieModel : Hashable, Codable, Equatable {

    var id : Int
    var title : String
    var releaseYear : Int
    var animated : Bool = false
    var played : Bool = false
    
}
