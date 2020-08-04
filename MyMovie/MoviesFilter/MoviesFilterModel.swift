//
//  MoviesFilterModel.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 03.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

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

enum MoviesFilterReleaseDate {
    case any
    case value(Date)
}

struct MoviesFilterModel {
    var isAdult: Bool
    var voteAverageLte: Int
    var voteAverageGte: Int
    var voteCount: MoviesFilterVoteCount
    var releaseDateLte: MoviesFilterReleaseDate
    var releaseDateGte: MoviesFilterReleaseDate
}
