//
//  MoviesDetail.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 19.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

struct MovieDetailResponse: Codable {
    let adult: Bool
    let backdropPath: String?
    // FIXME: Этот тип приходит как object
    //let belongsToCollection: Any
    let budget: Int?
    let genres: [MovieGenre]
    let homepage: String?
    let id: Int
    let imdbID: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: Date
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        //case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.backdropPath = try container.decode(String?.self, forKey: .backdropPath)
        self.budget = try container.decode(Int?.self, forKey: .budget)
        
        self.genres = (try container.decode([MovieDetailGenre].self, forKey: .genres)).map({ $0.movieGenre })

        self.homepage = try container.decode(String?.self, forKey: .homepage)
        self.id = try container.decode(Int.self, forKey: .id)
        self.imdbID = try container.decode(String?.self, forKey: .imdbID)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.overview = try container.decode(String?.self, forKey: .overview)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.posterPath = try container.decode(String?.self, forKey: .posterPath)
        self.productionCompanies = try container.decode([ProductionCompany].self, forKey: .productionCompanies)
        self.productionCountries = try container.decode([ProductionCountry].self, forKey: .productionCountries)
    
        let releaseDate = try container.decode(String.self, forKey: .releaseDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        self.releaseDate = dateFormatter.date(from: releaseDate) ?? Date()
        
        self.revenue = try container.decode(Int.self, forKey: .revenue)
        self.runtime = try container.decode(Int?.self, forKey: .runtime)
        self.spokenLanguages = try container.decode([SpokenLanguage].self, forKey: .spokenLanguages)
        self.status = try container.decode(String.self, forKey: .status)
        self.tagline = try container.decode(String.self, forKey: .tagline)
        self.title = try container.decode(String.self, forKey: .title)
        self.video = try container.decode(Bool.self, forKey: .video)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
    }
}

// MARK: - ProductionCompany
struct MovieDetailGenre: Codable {
    let id: Int
    let name: String
    
    var movieGenre: MovieGenre {
        return MovieGenre(rawValue: self.id) ?? .action
    }
}

struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let iso639_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case name
    }
}
