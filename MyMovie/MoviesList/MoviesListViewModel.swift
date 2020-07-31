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
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(backendController: BackendDiscoverController) {
        self.backendController = backendController
    }
    
    func start() {
        self.bindingToProperties()
        self.loadMovies(page: self.currentPage, sortBy: self.sortType)
    }
    
    private func bindingToProperties() {
        Publishers.CombineLatest3(self.$currentPage, self.$filter, self.$sortType)
            .sink(receiveValue: { (value) in
                var page = value.0
                let filter = value.1
                let sortType = value.2
                
                if self.filter != filter || self.sortType != sortType {
                    self.currentPage = 1
                    page = 1
                }
                
                self.loadMovies(page: page, sortBy: sortType)
            })
        .store(in: &self.cancellables)
    }
    
    // MARK: - Mehtods
    func loadMovies(page: Int, sortBy: MovieSortingType) {
        self.backendController.getMovies(model: MovieDiscoverRequest(language: Locale.preferredLanguages.first, region: Locale.current.regionCode, sortBy: sortBy, page: page))
            .sink(receiveCompletion: { (completion) in
                print()
            }) { (response) in
                // FIXME: не хорошая проверка, по хорошему надо все остальные запросы останавливать
                if response.page == self.currentPage {
                    if response.page == 1 {
                        self.discoveredMovies = response.results
                    } else {
                        self.discoveredMovies.append(contentsOf: response.results)
                    }
                }
        }
        .store(in: &self.cancellables)
    }
}
