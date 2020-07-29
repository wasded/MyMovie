//
//  BackendDiscoverController.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 29.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Combine

protocol BackendDiscoverController: class {
    func getMovies(language: String?, region: String?, sortBy: Int?, certificationCountry: String?, certification: String?, certificationLte: String?, certificationGte: String?, includeAdult: Bool?, includeVideo: Bool?, page: Int, primaryReleaseYear: Int?, primaryReleaseDateLte: String?, primaryReleaseDateGte: String?, releaseDateLte: String?, releaseDateGte: String?, withReleaseType: Int?, year: Int?, voteCountLte: Double?, voteCountGte: Double?, voteAverageLte: Double?, voteAverageGte: Double?, withCast: String?, withCrew: String?, withPeople: String?, withCompanies: String?, withGenres: String?, withoutGenres: String?, withKeywords: String?, withRuntimeLte: String?, withRuntimeGte: String?, withOriginalLanguage: String?) -> AnyPublisher<PagingModel<MovieDiscover>, Error>
}
