//
//  MoviesFilterListViewModel.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 31.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Combine

struct MoviesFilterListPickerData<T> {
    var title: String
    var value: T
}

// FIXME: Какой-то большой тип данных получается из-за картэжей, стоит поменять на структуру
class MoviesFilterListViewModel {
    // MARK: - Properties
    @Published var filtredVoteAveragePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>](), maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]())
    
    @Published var voteAverageText: String = ""
    @Published var voteCountText: String = ""
    
    var moviesFilterModel: MoviesFilterModel
    var voteAveragePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>](), maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]())
    var voteCountPickerViewData = [MoviesFilterListPickerData<MoviesFilterVoteCount>]()
    
    var cancellables: Set<AnyCancellable> = []
    
    private var voteAverageMaximumValue = 10
    
    // MARK: - Init
    init(moviesFilterModel: MoviesFilterModel) {
        self.moviesFilterModel = moviesFilterModel
        
        self.voteAveragePickerViewData = self.getVoteAverageItems()
        self.voteAverageDidChanged(minimum: self.moviesFilterModel.voteAverageLte, maximum: self.moviesFilterModel.voteAverageGte)
        
        self.voteCountPickerViewData = self.getVoteCountItems()
        self.voteCountDidChanged(voteCount: self.moviesFilterModel.voteCount)
    }
    
    // MARK: - Methods
    private func getVoteAverageItems() -> (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>], maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]) {
        var data = (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>](), maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]())
        
        data.minimum.append(MoviesFilterListPickerData(title: "Любая", value: .any))
        data.maximum.append(MoviesFilterListPickerData(title: "Любая", value: .any))
        
        for index in 1...10 {
            data.minimum.append(MoviesFilterListPickerData(title: String(index), value: .value(index)))
            data.maximum.append(MoviesFilterListPickerData(title: String(index), value: .value(index)))
        }
        
        return data
    }
    
    private func getVoteCountItems() -> [MoviesFilterListPickerData<MoviesFilterVoteCount>] {
        var data = [MoviesFilterListPickerData<MoviesFilterVoteCount>]()
        
        data.append(contentsOf: MoviesFilterVoteCount.allCases.map({ MoviesFilterListPickerData(title: $0.getTitle(), value: $0) }))
        
        return data
    }
    
    func getVoteAverageText() -> String {
        let voteAverageText: String
        switch (self.moviesFilterModel.voteAverageLte, self.moviesFilterModel.voteAverageGte) {
        case (.any, .any):
            voteAverageText = "Любая"
        case (.any, .value(let maximumValue)):
            if maximumValue == self.voteAverageMaximumValue {
                voteAverageText = String(format: "%d", maximumValue)
            } else {
                voteAverageText = String(format: "%d и менее", maximumValue)
            }
        case (.value(let minimumValue), .any):
            if minimumValue == self.voteAverageMaximumValue {
                voteAverageText = String(format: "%d", minimumValue)
            } else {
                voteAverageText = String(format: "%d и более", minimumValue)
            }
        case (.value(let minimumValue), .value(let maximumValue)):
            if minimumValue == maximumValue {
                voteAverageText = String(format: "%d", minimumValue)
            } else {
                voteAverageText = String(format: "%d - %d", minimumValue, maximumValue)
            }
        }
        
        return voteAverageText
    }
    
    func isAdultDidChanged(_ isAdult: Bool) {
        self.moviesFilterModel.isAdult = isAdult
    }
    
    func voteAverageDidChanged(minimum: MoviesFilterVoteAverage?, maximum: MoviesFilterVoteAverage?) {
        if let minimum = minimum {
            self.moviesFilterModel.voteAverageLte = minimum
        }
        
        if let maximum = maximum {
            self.moviesFilterModel.voteAverageGte = maximum
        }
        
        self.voteAverageText = self.getVoteAverageText()
        
        // filter
        var filtredVoteAveragePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>](), maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]())
        
        switch self.moviesFilterModel.voteAverageLte {
        case .any:
            filtredVoteAveragePickerViewData.maximum = self.voteAveragePickerViewData.maximum
        case .value(let minimumValue):
            filtredVoteAveragePickerViewData.maximum = self.voteAveragePickerViewData.maximum.filter({ (item) -> Bool in
                switch item.value {
                case .any:
                    return true
                case .value(let maximumValue):
                    return maximumValue >= minimumValue
                }
            })
        }
        
        switch self.moviesFilterModel.voteAverageGte {
        case .any:
            filtredVoteAveragePickerViewData.minimum = self.voteAveragePickerViewData.minimum
        case .value(let maximumValue):
            filtredVoteAveragePickerViewData.minimum = self.voteAveragePickerViewData.minimum.filter({ (item) -> Bool in
                switch item.value {
                case .any:
                    return true
                case .value(let minimumValue):
                    return minimumValue <= maximumValue
                }
            })
        }
        
        self.filtredVoteAveragePickerViewData = filtredVoteAveragePickerViewData
    }
    
    func voteCountDidChanged(voteCount: MoviesFilterVoteCount) {
        self.moviesFilterModel.voteCount = voteCount
        
        self.voteCountText = voteCount.getTitle()
    }
}
