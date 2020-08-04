//
//  MoviesFIlterGenresListViewModel+Data.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 04.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

extension MoviesFilterGenresListViewModel {
    func getItems(selectedGenres: Set<MovieGenre>, filterType: Int) -> [MovieGenreTableViewCellData] {
        return MovieGenre.allCases.map({ MovieGenreTableViewCellData(type: $0, isSelected: selectedGenres.contains($0)) })
    }
}
