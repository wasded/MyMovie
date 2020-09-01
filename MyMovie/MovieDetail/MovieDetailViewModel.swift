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

struct MovieDetailModel {
    var headerData: MovieDetailHeaderData
}

class MovieDetailViewModel {
    // MARK: - Proprties
    @Injected var backendController: BackendMoviesController
    
    @Published var movieDetailModel: MovieDetailModel?
    
    private var cancellables: Set<AnyCancellable> = []
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter
    }
    
    // MARK: - Init
    init(backendController: BackendMoviesController) {
        self.backendController = backendController
    }
    
    // MARK: - Methods
    func getMovieDetail(movieID: Int) {
        self.backendController.getDetail(movieID: movieID, language: Locale.current.languageCode ?? "ru_RU", appendToResponse: nil)
            .sink(receiveCompletion: { (completion) in
            }) { (response) in
                self.movieDetailModel = self.generateMovieDetailModel(from: response)
        }
        .store(in: &self.cancellables)
    }
    
    func generateMovieDetailModel(from movieDetailResponse: MovieDetailResponse) -> MovieDetailModel {
        let urlPoster: URL?
        
        if let posterPath = movieDetailResponse.posterPath {
            urlPoster = APIHelper.getPosterURL(posterType: .original, posterPath: posterPath)
        } else {
            urlPoster = nil
        }
        
        let releaseDate = self.dateFormatter.string(from: movieDetailResponse.releaseDate)
        let genres = movieDetailResponse.genres.map({ $0.name }).joined(separator: ", ")
        let countries = movieDetailResponse.productionCountries.map({ $0.name }).joined(separator: ", ")
        
        let info = String(format: "%@ • %@ • %@", releaseDate, genres, countries)
        
        
        return MovieDetailModel(headerData: MovieDetailHeaderData(posterURL: urlPoster,
                                                                  title: movieDetailResponse.title,
                                                                  info: info))
    }
}
