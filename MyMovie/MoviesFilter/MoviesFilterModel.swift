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
    
    var value: Double? {
        switch self {
        case .any:
            return nil
        case .value(let value):
            return Double(value)
        }
    }
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
    
    var gte: Int? {
        switch self {
        case .any:
            return nil
        case .few:
            return nil
        case .medium:
            return 500
        case .many:
            return 1500
        }
    }
    
    var lte: Int? {
        switch self {
        case .any:
            return nil
        case .few:
            return 500
        case .medium:
            return 100
        case .many:
            return nil
        }
    }
}

enum MoviesFilterReleaseDate {
    case any
    case value(Date)
    
    var value: Date? {
        switch self {
        case .any:
            return nil
        case .value(let value):
            return value
        }
    }
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
    
    var gte: Int? {
        switch self {
        case .any:
            return nil
        case .short:
            return nil
        case .medium:
            return 60
        case .long:
            return 60
        }
    }
    
    var lte: Int? {
        switch self {
        case .any:
            return nil
        case .short:
            return 60
        case .medium:
            return 100
        case .long:
            return nil
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
    var genres: Set<MovieGenre> = Set<MovieGenre>()
}
