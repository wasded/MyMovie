//
//  MovieDetailViewModel+Data.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 03.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

protocol MovieDetailCell {
    var isSelectable: Bool { get }
}

struct MovieDetailSection {
    var items: [MovieDetailCell]
    
    init(items: [MovieDetailCell] = []) {
        self.items = items
    }
}

extension MovieDetailViewModel {
    func getData(model: MovieDetailResponse) -> [MovieDetailSection] {
        var sections = [MovieDetailSection]()
        
        sections.append(self.getMovieSection())
        
        return sections
    }
    
    func getMovieSection() -> MovieDetailSection {
        var section = MovieDetailSection()
        
        section.items.append(self.getActionsCell())
        
        return section
    }
    
    func getActionsCell() -> MovieDetailActionsCellData {
        return MovieDetailActionsCellData(isWatchLater: false, isFavorite: false)
    }
}
