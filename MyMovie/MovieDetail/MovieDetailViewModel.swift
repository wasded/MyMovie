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

struct FullMovieInfo {
    let movieInfo: MovieDetailResponse
    let movieCredits: MovieCreditsResponse
}

class MovieDetailViewModel {
    // MARK: - Proprties
    
    @Injected var backendController: BackendMoviesController
    
    @Published var movieDetailModel: MovieDetailModel?
    
    @Published private(set) var movieInfo: MovieDetailResponse?
    @Published private(set) var movieCredits: MovieCreditsResponse?
    
    private(set) var fullMovieInfo: FullMovieInfo?
    
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
        self.bindingToProperties()
    }
    
    // MARK: - Methods
    func start() {
        self.getMovieDetail()
        self.getMovieCredits()
    }
    
    func getMovieDetail() {
        self.backendController.getDetail(movieID: self.movieID, language: Locale.preferredLanguages.first, appendToResponse: nil)
            .sink(receiveCompletion: { (completion) in
                print()
            }) { (response) in
                self.movieInfo = response
        }
        .store(in: &self.cancellables)
    }
    
    func getMovieCredits() {
        self.backendController.getCredits(movieID: self.movieID)
            .sink(receiveCompletion: { (completion) in
                print()
            }) { (response) in
                self.movieCredits = response
        }
        .store(in: &self.cancellables)
    }
    
    func generateMovieDetailModel(fullMovieInfo: FullMovieInfo) -> MovieDetailModel {
        let urlPoster: URL?
        
        if let posterPath = fullMovieInfo.movieInfo.posterPath {
            urlPoster = APIHelper.getPosterURL(posterType: .original, posterPath: posterPath)
        } else {
            urlPoster = nil
        }
        
        let releaseDate = self.dateFormatter.string(from: fullMovieInfo.movieInfo.releaseDate)
        let genres = fullMovieInfo.movieInfo.genres.map({ $0.name }).joined(separator: ", ")
        let countries = fullMovieInfo.movieInfo.productionCountries.map({ $0.name }).joined(separator: ", ")
        
        let info = String(format: "%@ • %@ • %@", releaseDate, genres, countries)
        
        return MovieDetailModel(headerData: MovieDetailHeaderData(posterURL: urlPoster,
                                                                  title: fullMovieInfo.movieInfo.title,
                                                                  info: info),
                                sections: self.getData(fullMovieInfo: fullMovieInfo))
    }
    
    private func bindingToProperties() {
        Publishers.CombineLatest(self.$movieInfo, self.$movieCredits)
            .compactMap({ (value) -> FullMovieInfo? in
                if let movieInfo = value.0, let movieCredits = value.1 {
                    return FullMovieInfo(movieInfo: movieInfo, movieCredits: movieCredits)
                } else {
                    return nil
                }
            })
            .sink(receiveCompletion: { (_) in
            }) { (fullMovieInfo) in
                self.movieDetailModel = self.generateMovieDetailModel(fullMovieInfo: fullMovieInfo)
                
        }
        .store(in: &self.cancellables)
    }
}
