//
//  MovieCreditsResponse.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 04.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

// MARK: - MovieCreditsResponse
struct MovieCreditsResponse: Decodable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case cast
//    }
}

// MARK: - Cast
struct Cast: Decodable {
    let castID: Int
    let character, creditID: String
    let gender, id: Int
    let name: String
    let order: Int
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case gender, id, name, order
        case profilePath = "profile_path"
    }
}

// MARK: - Crew
struct Crew: Decodable {
    let creditID, department: String
    let gender, id: Int
    let job, name: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case creditID = "credit_id"
        case department, gender, id, job, name
        case profilePath = "profile_path"
    }
}
