//
//  MovieDetailViewModel.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 06.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Combine
import Resolver

class MovieDetailViewModel {
    // MARK: - Proprties
    @Injected var backendController: BackendMoviesController
    
    // MARK: - Init
    init(backendController: BackendMoviesController) {
        self.backendController = backendController
    }
    
    // MARK: - Methods
    func getMovieDetail(movieID: Int) -> AnyPublisher<MoviesDetailResponse, Error> {
        return self.backendController.getDetail(movieID: movieID, language: Locale.current.languageCode ?? "ru_RU", appendToResponse: nil)
    }
}
