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
        var moviePersonInfo = [MoviePersonInfo]()
        
        moviePersonInfo.append(contentsOf:movieCredits.cast
            .prefix(5)
            .map { (value) -> MoviePersonInfo in
                let name = value.name.replacingOccurrences(of: " ", with: "\n")
                let imageURL: URL?
                
                if let profilePath = value.profilePath {
                    imageURL = APIHelper.getImageURL(posterType: .original, posterPath: profilePath)
                } else {
                    imageURL = nil
                }
                
                return MoviePersonInfo(name: name, job: "Актер", imageURL: imageURL)
        })
        
        moviePersonInfo.append(contentsOf:movieCredits.crew
            .prefix(2)
            .map { (value) -> MoviePersonInfo in
                let name = value.name.replacingOccurrences(of: " ", with: "\n")
                let imageURL: URL?
                
                if let profilePath = value.profilePath {
                    imageURL = APIHelper.getImageURL(posterType: .original, posterPath: profilePath)
                } else {
                    imageURL = nil
                }
                
                return MoviePersonInfo(name: name, job: value.job, imageURL: imageURL)
        })
        
        return MovieDetailCrewCellData(crew: moviePersonInfo.shuffled())
    }
}
