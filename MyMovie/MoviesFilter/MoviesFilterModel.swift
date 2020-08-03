//
//  MoviesFilterModel.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 03.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

enum MoviesFilterVoteAverage {
    case any
    case value(Int)
}

struct MoviesFilterModel {
    var voteAverageLte: MoviesFilterVoteAverage
    var voteAverageGte: MoviesFilterVoteAverage
}
