//
//  MovieDiscoverRequest.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 29.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

struct MovieDiscoverRequest: Codable {
    // MARK: - Properties
    var language: String?
    var region: String?
    var sortBy: MovieSortingType?
    var certificationCountry: String?
    var certification: String?
    var certificationLte: String?
    var certificationGte: String?
    var includeAdult: Bool?
    var includeVideo: Bool?
    var page: Int?
    var primaryReleaseYear: Int?
    var primaryReleaseDateLte: String?
    var primaryReleaseDateGte: String?
    var releaseDateLte: String?
    var releaseDateGte: String?
    var withReleaseType: Int?
    var year: Int?
    var voteCountLte: Int?
    var voteCountGte: Int?
    var voteAverageLte: Double?
    var voteAverageGte: Double?
    var withCast: String?
    var withCrew: String?
    var withPeople: String?
    var withCompanies: String?
    var withGenres: String?
    var withoutGenres: String?
    var withKeywords: String?
    var withoutKeywords: String?
    var withRuntimeLte: Int? // FIXME: не понятно что это, похоже на продолжительность, но если lte = 0 gte = 60 то сервер возвращает фильмы которые > 60
    var withRuntimeGte: Int?
    var withOriginalLanguage: String?
    
    enum CodingKeys: String, CodingKey {
        case language
        case region
        case sortBy = "sort_by"
        case certificationCountry = "certification_country"
        case certification
        case certificationLte = "certification.lte"
        case certificationGte = "certification.gte"
        case includeAdult = "include_adult"
        case includeVideo = "include_video"
        case page
        case primaryReleaseYear = "primary_release_year"
        case primaryReleaseDateLte = "primary_release_date.lte"
        case primaryReleaseDateGte = "primary_release_date.gte"
        case releaseDateLte = "release_date.lte"
        case releaseDateGte = "release_date.gte"
        case withReleaseType = "with_release_type"
        case year
        case voteCountLte = "vote_count.lte"
        case voteCountGte = "vote_count.gte"
        case voteAverageLte = "vote_average.lte"
        case voteAverageGte = "vote_average.gte"
        case withCast = "with_cast"
        case withCrew = "with_crew"
        case withPeople = "with_people"
        case withCompanies = "with_companies"
        case withGenres = "with_genres"
        case withoutGenres = "without_genres"
        case withKeywords = "with_keywords"
        case withoutKeywords = "without_keywords"
        case withRuntimeLte = "with_runtime.lte"
        case withRuntimeGte = "with_runtime.gte"
        case withOriginalLanguage = "with_original_language"
    }
    
    // MARK: - Init
    init(language: String? = nil, region: String? = nil, sortBy: MovieSortingType? = nil, certificationCountry: String? = nil, certification: String? = nil, certificationLte: String? = nil, certificationGte: String? = nil, includeAdult: Bool? = nil, includeVideo: Bool? = nil, page: Int? = nil, primaryReleaseYear: Int? = nil, primaryReleaseDateLte: String? = nil, primaryReleaseDateGte: String? = nil, releaseDateLte: String? = nil, releaseDateGte: String? = nil, withReleaseType: Int? = nil, year: Int? = nil, voteCountLte: Int? = nil, voteCountGte: Int? = nil, voteAverageLte: Double? = nil, voteAverageGte: Double? = nil, withCast: String? = nil, withCrew: String? = nil, withPeople: String? = nil, withCompanies: String? = nil, withGenres: String? = nil, withoutGenres: String? = nil, withKeywords: String? = nil, withoutKeywords: String? = nil, withRuntimeLte: Int? = nil, withRuntimeGte: Int? = nil, withOriginalLanguage: String? = nil) {
        self.language = language
        self.region = region
        self.sortBy = sortBy
        self.certificationCountry = certificationCountry
        self.certification = certification
        self.certificationLte = certificationLte
        self.certificationGte = certificationGte
        self.includeAdult = includeAdult
        self.includeVideo = includeVideo
        self.page = page
        self.primaryReleaseYear = primaryReleaseYear
        self.primaryReleaseDateLte = primaryReleaseDateLte
        self.primaryReleaseDateGte = primaryReleaseDateGte
        self.releaseDateLte = releaseDateLte
        self.releaseDateGte = releaseDateGte
        self.withReleaseType = withReleaseType
        self.year = year
        self.voteCountLte = voteCountLte
        self.voteCountGte = voteCountGte
        self.voteAverageLte = voteAverageLte
        self.voteAverageGte = voteAverageGte
        self.withCast = withCast
        self.withCrew = withCrew
        self.withPeople = withPeople
        self.withCompanies = withCompanies
        self.withGenres = withGenres
        self.withoutGenres = withoutGenres
        self.withKeywords = withKeywords
        self.withoutKeywords = withoutKeywords
        self.withRuntimeLte = withRuntimeLte
        self.withRuntimeGte = withRuntimeGte
        self.withOriginalLanguage = withOriginalLanguage
    }
}
