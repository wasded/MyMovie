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

enum MoviesFilterVoteCount: CaseIterable {
    case any
    case few
    case medium
    case many
    
    func getTitle() -> String {
        switch self {
        case .any:
            return "Любое"
        case .few:
            return "Мало"
        case .medium:
            return "Средне"
        case .many:
            return "Много"
        }
    }
}

struct MoviesFilterModel {
    var isAdult: Bool
    var voteAverageLte: MoviesFilterVoteAverage
    var voteAverageGte: MoviesFilterVoteAverage
    var voteCount: MoviesFilterVoteCount
}
