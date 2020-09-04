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
        
        sections.append(self.getMovieSection(model: model))
        
        return sections
    }
    
    func getMovieSection(model: MovieDetailResponse) -> MovieDetailSection {
        var section = MovieDetailSection()
        
        section.items.append(self.getActionsCell())
        section.items.append(self.getDescriptionCell(model: model))
        
        return section
    }
    
    func getActionsCell() -> MovieDetailActionsCellData {
        return MovieDetailActionsCellData(isWatchLater: false, isFavorite: false)
    }
    
    func getDescriptionCell(model: MovieDetailResponse) -> MovieDetailDescriptionCellData {
        return MovieDetailDescriptionCellData(descritpion: model.overview)
    }
}
