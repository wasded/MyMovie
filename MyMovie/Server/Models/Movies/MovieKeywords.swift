//
//  MovieKeywordsResponse.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 07.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

// MARK: - MovieKeywordsResponse
struct MovieKeywordsResponse: Codable {
    let id: Int
    let keywords: [Keyword]
}

// MARK: - Keyword
struct Keyword: Codable {
    let id: Int
    let name: String
}
