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
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(backendController: BackendDiscoverController) {
        self.backendController = backendController
    }
    
    // MARK: - Mehtods
    func loadMovies() {
        self.backendController.getMovies(model: MovieDiscoverRequest())
            .sink(receiveCompletion: { (completion) in
                print()
            }) { (response) in
                self.wasFirstLoad = true // Пока не могу придумать способа лучше и быстрее
                self.discoveredMovies = response.results
        }
        .store(in: &self.cancellables)
    }
}
