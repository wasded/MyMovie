//
//  MovieDiscover.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 29.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

struct MovieDiscover: Codable {
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let posterPath: String?
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let originalLanguage: String
    let originalTitle: String
    let genreIDS: [Int]
    let title: String
    let voteAverage: Double
    let overview: String
    let releaseDate: Date

    enum CodingKeys: String, CodingKey {
        case popularity
        case voteCount = "vote_count"
        case video
        case posterPath = "poster_path"
        case id
        case adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
        self.video = try container.decode(Bool.self, forKey: .video)
        self.posterPath = try container.decode(String?.self, forKey: .posterPath)
        self.id = try container.decode(Int.self, forKey: .id)
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.backdropPath = try container.decode(String?.self, forKey: .backdropPath)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.genreIDS = try container.decode([Int].self, forKey: .genreIDS)
        self.title = try container.decode(String.self, forKey: .title)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.overview = try container.decode(String.self, forKey: .overview)
        
        let releaseDate = try container.decode(String.self, forKey: .releaseDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        self.releaseDate = dateFormatter.date(from: releaseDate) ?? Date()
    }
    
    func getPosterURL(posterType: APIConstants.PosterType) -> URL? {
        if let posterPath = self.posterPath {
            return URL(string: String(format: "%@/%@/%@", APIConstants.urlOriginalPoster, posterType.getURLParameter(), posterPath))
        } else {
            return nil
        }
    }
}

extension MovieDiscover: Equatable { }
