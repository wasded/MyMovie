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
    
    var title: String {
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

enum MoviesFilterDuration: CaseIterable {
    case any
    case short
    case medium
    case long
    
    var title: String {
        switch self {
        case .any:
            return "Любая"
        case .short:
            return "Короткая"
        case .medium:
            return "Средняя"
        case .long:
            return "Длинная"
        }
    }
}

struct MoviesFilterModel {
    var isAdult: Bool = false
    var voteAverageLte: MoviesFilterVoteAverage = .any
    var voteAverageGte: MoviesFilterVoteAverage = .any
    var voteCount: MoviesFilterVoteCount = .any
    var releaseDateLte: MoviesFilterReleaseDate = .any
    var releaseDateGte: MoviesFilterReleaseDate = .any
    var duration: MoviesFilterDuration = .any
}
