//
//  MoviesFilterListViewModel.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 31.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct MoviesFilterListPickerData<T> {
    var title: String
    var value: T
}

// FIXME: Какой-то большой тип данных получается из-за картэжей, стоит поменять на структуру
class MoviesFilterListViewModel {
    // MARK: - Properties
    @Published var filtredVoteAveragePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>](), maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]())
    @Published var filtredReleaseDatePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>](), maximum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>]())
    
    @Published var voteAverageText: String = ""
    @Published var voteCountText: String = ""
    @Published var releaseDateText: String = ""
    @Published var durationText: String = ""
    
    var filterModel: MoviesFilterModel
    var voteAveragePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>](), maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]())
    var voteCountPickerViewData = [MoviesFilterListPickerData<MoviesFilterVoteCount>]()
    var releaseDatePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>](), maximum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>]())
    var durationDatePickerViewData = [MoviesFilterListPickerData<MoviesFilterDuration>]()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let voteAverageMinimumValue = 0
    private let voteAverageMaximumValue = 10
    private let firstMovieReleaseDate = Date(timeIntervalSince1970: -2366755200)
    lazy private var minimumReleaseDate: Date = {
        var components = Calendar.current.dateComponents([.year], from: self.firstMovieReleaseDate)
        return Calendar.current.date(from: components)!
    }()
    // FIXME: Будем брать максимальную дату выходу текущийГод + 25 лет. Вообще можно кидать запрос на сервер с сортировкой по годам и брать самый большой по году фильм.
    private let maximumReleaseDate: Date = {
        var components = Calendar.current.dateComponents([.year], from: Date())
        let startNextYear = Calendar.current.date(from: DateComponents(year: components.year! + 26, month: 1, day: 1))!
        return Calendar.current.date(byAdding: .day, value: -1, to: startNextYear)!
    }()
    
    // MARK: - Init
    init(moviesFilterModel: MoviesFilterModel) {
        self.filterModel = moviesFilterModel
        
        self.voteAveragePickerViewData = self.getVoteAverageItems()
        self.voteAverageDidChanged(minimum: self.filterModel.voteAverageLte, maximum: self.filterModel.voteAverageGte)
        
        self.voteCountPickerViewData = self.getVoteCountItems()
        self.voteCountDidChanged(voteCount: self.filterModel.voteCount)
        
        self.releaseDatePickerViewData = self.getReleaseDateItems()
        self.releaseDateDidChanged(minimum: self.filterModel.releaseDateLte, maximum: self.filterModel.releaseDateGte)
        
        self.durationDatePickerViewData = self.getDurationItems()
        self.durationDidChanged(self.filterModel.duration)
    }
    
    // MARK: - Methods
    func isAdultDidChanged(_ isAdult: Bool) {
        self.filterModel.isAdult = isAdult
    }
    
    func voteAverageDidChanged(minimum: MoviesFilterVoteAverage?, maximum: MoviesFilterVoteAverage?) {
        if let minimum = minimum {
            self.filterModel.voteAverageLte = minimum
        }
        
        if let maximum = maximum {
            self.filterModel.voteAverageGte = maximum
        }
        
        self.voteAverageText = self.getVoteAverageText()
        
        // filter
        var filtredVoteAveragePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>](), maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]())
        
        switch self.filterModel.voteAverageLte {
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
        
        switch self.filterModel.voteAverageGte {
            case .any:
                filtredVoteAveragePickerViewData.minimum = self.voteAveragePickerViewData.minimum
        case .value(let maximumValue):
            filtredVoteAveragePickerViewData.maximum = self.voteAveragePickerViewData.maximum.filter({ (item) -> Bool in
                switch item.value {
                case .any:
                    return true
                case .value(let minimumValue):
                    return maximumValue >= minimumValue
                }
            })
        }
        
        self.filtredVoteAveragePickerViewData = filtredVoteAveragePickerViewData
    }
    
    func voteCountDidChanged(voteCount: MoviesFilterVoteCount) {
        self.filterModel.voteCount = voteCount
        
        self.voteCountText = voteCount.title
    }
    
    func releaseDateDidChanged(minimum: MoviesFilterReleaseDate?, maximum: MoviesFilterReleaseDate?) {
        if let minimum = minimum {
            self.filterModel.releaseDateLte = minimum
        }
        
        if let maximum = maximum {
            self.filterModel.releaseDateGte = maximum
        }
        
        // filter
        var filtredReleaseDatePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>](), maximum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>]())
        
        switch self.filterModel.releaseDateLte {
        case .any:
            filtredReleaseDatePickerViewData.maximum = self.releaseDatePickerViewData.maximum
        case .value(let minimumValue):
            filtredReleaseDatePickerViewData.maximum = self.releaseDatePickerViewData.maximum.filter({ (item) -> Bool in
                switch item.value {
                case .any:
                    return true
                case .value(let value):
                    return value >= minimumValue
                }
            })
        }
        
        switch self.filterModel.releaseDateGte {
        case .any:
            filtredReleaseDatePickerViewData.minimum = self.releaseDatePickerViewData.minimum
        case .value(let maximumValue):
            filtredReleaseDatePickerViewData.minimum = self.releaseDatePickerViewData.minimum.filter({ (item) -> Bool in
                switch item.value {
                case .any:
                    return true
                case .value(let value):
                    return value <= maximumValue
                }
            })
        }
        
        self.filtredReleaseDatePickerViewData = filtredReleaseDatePickerViewData
        
        self.releaseDateText = self.getReleaseDateText()
    }
    
    func durationDidChanged(_ duration: MoviesFilterDuration) {
        self.filterModel.duration = duration
        
        self.durationText = duration.title
    }
    
    // MARK: - PickerView items
    private func getVoteAverageItems() -> (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>], maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]) {
        var data = (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>](), maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]())
        
        data.minimum.append(MoviesFilterListPickerData(title: "Любая", value: .any))
        data.maximum.append(MoviesFilterListPickerData(title: "Любая", value: .any))
        
        for index in self.voteAverageMinimumValue...self.voteAverageMaximumValue {
            data.minimum.append(MoviesFilterListPickerData(title: String(index), value: .value(index)))
            data.maximum.append(MoviesFilterListPickerData(title: String(index), value: .value(index)))
        }
        
        return data
    }
    
    private func getVoteCountItems() -> [MoviesFilterListPickerData<MoviesFilterVoteCount>] {
        // FIXME: Не очень крутая идея делать колличество оценок как "Много"/"Мало" без конкретного колличества, но делать поле где пользователь сам задает промежуток тоже не очень. Стоит подумать над тем чтобы логику перенести на другую страницу
        return MoviesFilterVoteCount.allCases.map({ MoviesFilterListPickerData<MoviesFilterVoteCount>(title: $0.title, value: $0) })
    }
    
    private func getReleaseDateItems() -> (minimum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>], maximum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>]) {
        var data = (minimum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>](), maximum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>]())
        
        data.minimum.append(MoviesFilterListPickerData(title: "Любая", value: .any))
        data.maximum.append(MoviesFilterListPickerData(title: "Любая", value: .any))
        
        let minimumYear = Calendar.current.dateComponents([.year], from: self.minimumReleaseDate).year!
        let maximumYear = Calendar.current.dateComponents([.year], from: self.maximumReleaseDate).year!
        
        for year in minimumYear...maximumYear {
            let minimumDate = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))!
            let maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(from: DateComponents(year: year+1, month: 1, day: 1))!)!
            
            data.minimum.append(MoviesFilterListPickerData(title: String(year), value: .value(minimumDate)))
            data.maximum.append(MoviesFilterListPickerData(title: String(year), value: .value(maximumDate)))
        }
        
        return data
    }
    
    private func getDurationItems() -> [MoviesFilterListPickerData<MoviesFilterDuration>] {
        return MoviesFilterDuration.allCases.map({ MoviesFilterListPickerData<MoviesFilterDuration>(title: $0.title, value: $0) })
    }
    
    // MARK: -
    private func getVoteAverageText() -> String {
        let voteAverageText: String
        switch (self.filterModel.voteAverageLte, self.filterModel.voteAverageGte) {
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
    
    private func getReleaseDateText() -> String {
        let releaseDateText: String
        
        switch (self.filterModel.releaseDateLte, self.filterModel.releaseDateGte) {
        case (.any, .any):
            releaseDateText = "Любая"
        case (.any, .value(let maximumValue)):
            let year = Calendar.current.component(.year, from: maximumValue)
            let maximumRequiredYear = Calendar.current.component(.year, from: self.maximumReleaseDate)
            if year == maximumRequiredYear {
                releaseDateText = String(format: "%d", year)
            } else {
                releaseDateText = String(format: "%d и позже", year)
            }
        case (.value(let minimumValue), .any):
            let year = Calendar.current.component(.year, from: minimumValue)
            let minimumRequiredYear = Calendar.current.component(.year, from: self.minimumReleaseDate)
            if year == minimumRequiredYear {
                releaseDateText = String(format: "%d", year)
            } else {
                releaseDateText = String(format: "%d и ранее", year)
            }
        case (.value(let minimumValue), .value(let maximumValue)):
            let minimumYear = Calendar.current.component(.year, from: minimumValue)
            let maximumYear = Calendar.current.component(.year, from: maximumValue)
            
            if minimumYear == maximumYear {
                releaseDateText = String(minimumYear)
            } else {
                releaseDateText = String(format: "%d - %d", minimumYear, maximumYear)
            }
        }
        
        return releaseDateText
    }
}
