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
    var sections: [MovieDetailSection]
    
    init(headerData: MovieDetailHeaderData, sections: [MovieDetailSection] = []) {
        self.headerData = headerData
        self.sections = sections
    }
}

class MovieDetailViewModel {
    // MARK: - Proprties
    @Injected var backendController: BackendMoviesController
    
    @Published var movieDetailModel: MovieDetailModel?
    
    let movieID: Int
    private var cancellables: Set<AnyCancellable> = []
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter
    }
    
    // MARK: - Init
    init(movieID: Int) {
        self.movieID = movieID
    }
    
    // MARK: - Methods
    func start() {
        self.backendController.getDetail(movieID: self.movieID, language: Locale.current.languageCode ?? "ru_RU", appendToResponse: nil)
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
                                                                  info: info),
                                sections: self.getData(model: movieDetailResponse))
    }
}
