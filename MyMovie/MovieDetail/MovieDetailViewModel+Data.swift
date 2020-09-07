//
//  MovieDetailViewModel+Data.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 03.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

struct MovieDetailSection {
    var items: [Any]
    
    init(items: [Any] = []) {
        self.items = items
    }
}

extension MovieDetailViewModel {
    func getData(fullMovieInfo: FullMovieInfo) -> [MovieDetailSection] {
        var sections = [MovieDetailSection]()
        
        var section = MovieDetailSection()
        
        section.items.append(self.getActionsCell())
        section.items.append(self.getDescriptionCell(movieInfo: fullMovieInfo.movieInfo))
        section.items.append(self.getCrewCell(movieCredits: fullMovieInfo.movieCredits))
        
        sections.append(section)
        
        return sections
    }
    
    func getActionsCell() -> MovieDetailActionsCellData {
        return MovieDetailActionsCellData(isWatchLater: false, isFavorite: false)
    }
    
    func getDescriptionCell(movieInfo: MovieDetailResponse) -> MovieDetailDescriptionCellData {
        return MovieDetailDescriptionCellData(descritpion: movieInfo.overview)
    }
    
    func getCrewCell(movieCredits: MovieCreditsResponse) -> MovieDetailCrewCellData {
        let moviePersonInfo = movieCredits.crew
            .prefix(5)
            .map({ MoviePersonInfo(name: $0.name, job: $0.job, imageURL: nil) })
        return MovieDetailCrewCellData(crew: moviePersonInfo)
    }
}
