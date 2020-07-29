//
//  MovieSortingType.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 29.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

enum MovieSortingType: String, Codable {
    case pupularityAsc = "popularity.asc"
    case popularityDesc = "popularity.desc"
    case releaseDateAsc = "release_date.asc"
    case releaseDateDesc = "release_date.desc"
    case revenueAsc = "revenue.asc"
    case revenueDesc = "revenue.desc"
    case primaryReleaseDateAsc = "primary_release_date.asc"
    case primaryReleaseDateDesc = "primary_release_date.desc"
    case originalTitleAsc = "original_title.asc"
    case originalTitleDesc = "original_title.desc"
    case voteAverageAsc = "vote_average.asc"
    case voteAverageDesc = "vote_average.desc"
    case voteCountAsc = "vote_count.asc"
    case voteCountDesc = "vote_count.desc"
}

extension MovieSortingType: Equatable { }
