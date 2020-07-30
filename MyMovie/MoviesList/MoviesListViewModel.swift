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
    @Published var wasFirstLoad: Bool = false
    @Published var sortType: MovieSortingType = .popularityDesc
    @Published var filter: Int = 0
    @Published var currentPage: Int = 1
    @Published var x: Int = 0
    
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
                self.loadMovies(page: value.0, sortBy: value.2)
            })
        .store(in: &self.cancellables)
    }
    
    // MARK: - Mehtods
    func loadMovies(page: Int, sortBy: MovieSortingType) {
        self.backendController.getMovies(model: MovieDiscoverRequest(sortBy: sortBy, page: page))
            .sink(receiveCompletion: { (completion) in
                print()
            }) { (response) in
                self.wasFirstLoad = true // Пока не могу придумать способа лучше и быстрее
                
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
