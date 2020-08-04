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
    @Published var filtredVoteAveragePickerViewData = (minimum: [MoviesFilterListPickerData<Int>](), maximum: [MoviesFilterListPickerData<Int>]())
    @Published var filtredReleaseDatePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>](), maximum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>]())
    
    @Published var voteAverageText: String = ""
    @Published var voteCountText: String = ""
    @Published var releaseDateText: String = ""
    
    var moviesFilterModel: MoviesFilterModel
    var voteAveragePickerViewData = (minimum: [MoviesFilterListPickerData<Int>](), maximum: [MoviesFilterListPickerData<Int>]())
    var voteCountPickerViewData = [MoviesFilterListPickerData<MoviesFilterVoteCount>]()
    var releaseDatePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>](), maximum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>]())
    
    var cancellables: Set<AnyCancellable> = []
    
    private let voteAverageAnyValue = -1
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
        self.moviesFilterModel = moviesFilterModel
        
        self.voteAveragePickerViewData = self.getVoteAverageItems()
        self.voteAverageDidChanged(minimum: self.moviesFilterModel.voteAverageLte, maximum: self.moviesFilterModel.voteAverageGte)
        
        self.voteCountPickerViewData = self.getVoteCountItems()
        self.voteCountDidChanged(voteCount: self.moviesFilterModel.voteCount)
        
        self.releaseDatePickerViewData = self.getReleaseDateItems()
        self.releaseDateDidChanged(minimum: self.moviesFilterModel.releaseDateLte, maximum: self.moviesFilterModel.releaseDateGte)
    }
    
    // MARK: - Methods
    
    func isAdultDidChanged(_ isAdult: Bool) {
        self.moviesFilterModel.isAdult = isAdult
    }
    
    func voteAverageDidChanged(minimum: Int?, maximum: Int?) {
        if let minimum = minimum {
            self.moviesFilterModel.voteAverageLte = minimum
        }
        
        if let maximum = maximum {
            self.moviesFilterModel.voteAverageGte = maximum
        }
        
        self.voteAverageText = self.getVoteAverageText()
        
        // filter
        var filtredVoteAveragePickerViewData = (minimum: [MoviesFilterListPickerData<Int>](), maximum: [MoviesFilterListPickerData<Int>]())
        
        if self.moviesFilterModel.voteAverageLte != self.voteAverageAnyValue {
            filtredVoteAveragePickerViewData.maximum = self.voteAveragePickerViewData.maximum.filter({ $0.value == self.voteAverageAnyValue || $0.value >= self.moviesFilterModel.voteAverageLte })
        } else {
            filtredVoteAveragePickerViewData.maximum = self.voteAveragePickerViewData.maximum
        }
        
        if self.moviesFilterModel.voteAverageGte != self.voteAverageAnyValue {
            filtredVoteAveragePickerViewData.minimum = self.voteAveragePickerViewData.minimum.filter({ $0.value == self.voteAverageAnyValue || $0.value <= self.moviesFilterModel.voteAverageGte })
        } else {
            filtredVoteAveragePickerViewData.minimum = self.voteAveragePickerViewData.minimum
        }
        
        self.filtredVoteAveragePickerViewData = filtredVoteAveragePickerViewData
    }
    
    func voteCountDidChanged(voteCount: MoviesFilterVoteCount) {
        self.moviesFilterModel.voteCount = voteCount
        
        self.voteCountText = voteCount.getTitle()
    }
    
    func releaseDateDidChanged(minimum: MoviesFilterReleaseDate?, maximum: MoviesFilterReleaseDate?) {
        if let minimum = minimum {
            self.moviesFilterModel.releaseDateLte = minimum
        }
        
        if let maximum = maximum {
            self.moviesFilterModel.releaseDateGte = maximum
        }
        
        // filter
        var filtredReleaseDatePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>](), maximum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>]())
        
        switch self.moviesFilterModel.releaseDateLte {
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
        
        switch self.moviesFilterModel.releaseDateGte {
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
    
    // MARK: - PickerView items
    private func getVoteAverageItems() -> (minimum: [MoviesFilterListPickerData<Int>], maximum: [MoviesFilterListPickerData<Int>]) {
        var data = (minimum: [MoviesFilterListPickerData<Int>](), maximum: [MoviesFilterListPickerData<Int>]())
        
        data.minimum.append(MoviesFilterListPickerData(title: "Любая", value: self.voteAverageAnyValue))
        data.maximum.append(MoviesFilterListPickerData(title: "Любая", value: self.voteAverageAnyValue))
        
        for index in self.voteAverageMinimumValue...self.voteAverageMaximumValue {
            data.minimum.append(MoviesFilterListPickerData(title: String(index), value: index))
            data.maximum.append(MoviesFilterListPickerData(title: String(index), value: index))
        }
        
        return data
    }
    
    private func getVoteCountItems() -> [MoviesFilterListPickerData<MoviesFilterVoteCount>] {
        var data = [MoviesFilterListPickerData<MoviesFilterVoteCount>]()
        
        // FIXME: Не очень крутая идея делать колличество оценок как "Много"/"Мало" без конкретного колличества, но делать поле где пользователь сам задает промежуток тоже не очень. Стоит подумать над тем чтобы логику перенести на другую страницу
        data.append(contentsOf: MoviesFilterVoteCount.allCases.map({ MoviesFilterListPickerData(title: $0.getTitle(), value: $0) }))
        
        return data
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
    
    // MARK: -
    private func getVoteAverageText() -> String {
        let voteAverageText: String
        switch (self.moviesFilterModel.voteAverageLte, self.moviesFilterModel.voteAverageGte) {
        case (self.voteAverageAnyValue, self.voteAverageAnyValue):
            voteAverageText = "Любая"
        case (self.voteAverageAnyValue, let maximumValue):
            if maximumValue == self.voteAverageMaximumValue {
                voteAverageText = String(format: "%d", maximumValue)
            } else {
                voteAverageText = String(format: "%d и менее", maximumValue)
            }
        case (let minimumValue, self.voteAverageAnyValue):
            if minimumValue == self.voteAverageMaximumValue {
                voteAverageText = String(format: "%d", minimumValue)
            } else {
                voteAverageText = String(format: "%d и более", minimumValue)
            }
        case (let minimumValue, let maximumValue):
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
        
        switch (self.moviesFilterModel.releaseDateLte, self.moviesFilterModel.releaseDateGte) {
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
