//
//  MoviesFIlterGenresListViewModel+Data.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 04.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

// FIXME: Возможно можно на дженериках сделать такой филтр универсальным
extension MoviesFilterGenresListViewModel {
    func getItems(selectedGenres: Set<MovieGenre>, sortingType: SortingType) -> [MovieGenreTableViewCellData] {
        var genres = MovieGenre.allCases
        
        // Сортировка по популярности тут фейковая)))
        switch sortingType {
        case .popularityAsc:
            genres.reverse()
        case .popularityDesc:
            break
        case .alphabeticallyAsc:
            genres.sort(by: { $0.name > $1.name } )
        case .alphabeticallyDesc:
            genres.sort(by: { $0.name < $1.name } )
        }
        
        return genres.map({ MovieGenreTableViewCellData(type: $0, isSelected: selectedGenres.contains($0)) })
    }
}
