//
//  MoviesFilterGenresListViewModel.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 04.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Combine

class MoviesFilterGenresListViewModel {
    enum SortingType {
        case popularityAsc
        case popularityDesc
        case alphabeticallyAsc
        case alphabeticallyDesc
    }
    
    // MARK: - Proprties
    @Published var items: [MovieGenreTableViewCellData] = []
    @Published var selectedGenres: Set<MovieGenre>
    @Published var sortingType: SortingType = .popularityDesc
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(selectedGenres: Set<MovieGenre>) {
        self.selectedGenres = selectedGenres
        self.bindingToProperties()
    }
    
    // MARK: - Methods
    private func bindingToProperties() {
        Publishers.CombineLatest(self.$selectedGenres, self.$sortingType)
            .sink { (value) in
                let selectedGenres = value.0
                let filterType = value.1
                
                self.items = self.getItems(selectedGenres: selectedGenres, sortingType: filterType)
                
        }
        .store(in: &self.cancellables)
    }
}
