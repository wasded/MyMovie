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
    var isAdult: Bool
    var voteAverageLte: Int
    var voteAverageGte: Int
    var voteCount: MoviesFilterVoteCount
    var releaseDateLte: MoviesFilterReleaseDate
    var releaseDateGte: MoviesFilterReleaseDate
    var duration: MoviesFilterDuration
}
