//
//  MoviesListViewModel.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 29.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Combine
import Resolver

class MoviesListViewModel {
    // MARK: - Properties
    @Injected var backendController: BackendDiscoverController
    
    @Published var discoveredMovies: [MovieDiscover] = []
    @Published var sortType: MovieSortingType = .popularityDesc
    @Published var filter: Int = 0
    @Published var currentPage: Int = 1
    @Published var filterModel = MoviesFilterModel()
    
    private var cancellables: Set<AnyCancellable> = []
    private let releasDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter
    }()
    private var getMoviesRequest: AnyCancellable?
    
    // MARK: - Init
    init(backendController: BackendDiscoverController) {
        self.backendController = backendController
    }
    
    func start() {
        self.bindingToProperties()
        self.loadMovies(page: self.currentPage, sortBy: self.sortType, filterModel: self.filterModel)
    }
    
    private func bindingToProperties() {
        Publishers.CombineLatest4(self.$currentPage, self.$filter, self.$sortType, self.$filterModel)
            .dropFirst()
            .sink(receiveValue: { [weak self] (value) in
                guard let self = self else { return }
                
                var page = value.0
                let filter = value.1
                let sortType = value.2
                let filterModel = value.3
                
                if self.filter != filter || self.sortType != sortType {
                    self.currentPage = 1
                    page = 1
                }
                
                self.loadMovies(page: page, sortBy: sortType, filterModel: filterModel)
            })
            .store(in: &self.cancellables)
    }
    
    // MARK: - Mehtods
    func loadMovies(page: Int, sortBy: MovieSortingType, filterModel: MoviesFilterModel) {
        self.getMoviesRequest?.cancel()
        
        var releaseLte: String?
        var releaseGte: String?
        
        if let releaseDateLte = filterModel.releaseDateLte.value {
            releaseLte = self.releasDateFormatter.string(from: releaseDateLte)
        }
        
        if let releaseDateGte = filterModel.releaseDateGte.value {
            releaseGte = self.releasDateFormatter.string(from: releaseDateGte)
        }
        
        let request = MovieDiscoverRequest(language: Locale.preferredLanguages.first,
                                           region: Locale.current.regionCode,
                                           sortBy: sortBy,
                                           includeAdult: filterModel.isAdult,
                                           page: page,
                                           releaseDateLte: releaseLte,
                                           releaseDateGte: releaseGte,
                                           voteCountLte: filterModel.voteCount.lte,
                                           voteCountGte: filterModel.voteCount.gte,
                                           voteAverageLte: filterModel.voteAverageLte.value,
                                           voteAverageGte: filterModel.voteAverageGte.value,
                                           withGenres: filterModel.genres.map({ $0.name }).joined(separator: ","),
                                           withRuntimeLte: filterModel.duration.lte,
                                           withRuntimeGte: filterModel.duration.gte)
        
        self.getMoviesRequest = self.backendController.getMovies(model: request)
            .sink(receiveCompletion: { (completion) in
            }) { (response) in
                if response.page == 1 {
                    self.discoveredMovies = response.results
                } else {
                    self.discoveredMovies.append(contentsOf: response.results)
                }
        }
    }
}
