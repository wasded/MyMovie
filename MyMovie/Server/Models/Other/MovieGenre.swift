//
//  MovieGenre.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 31.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation

// Вообще список жанров приходит с сервера, но я решил их захардкодить их enum'ом, так как удобнее будет работать
// Сделал так потому что жанр фильма приходит как [ID], тебе необходимо делать еще один запрос на сервер, для получение жанра, а потом в ответе название жанра смотреть
// Можно было конечно делать такой запрос 1 раз при включение приложения, но решил сделать через enum, на вряд ли список жанров меняется
// Плюсом там какие-то корявые переводы на русский)
enum MovieGenre: Int, Codable, CaseIterable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37
}

extension MovieGenre {
    var name: String {
        switch self {
        case .action:
            return "Боевик"
        case .adventure:
            return "Приключение"
        case .animation:
            return "Мультфильм"
        case .comedy:
            return "Комедия"
        case .crime:
            return "Криминал"
        case .documentary:
            return "Документальный"
        case .drama:
            return "Драма"
        case .family:
            return "Семейный"
        case .fantasy:
            return "Фэнтази"
        case .history:
            return "История"
        case .horror:
            return "Ужасы"
        case .music:
            return "Музыка"
        case .mystery:
            return "Мистика"
        case .romance:
            return "Мелодрама"
        case .scienceFiction:
            return "Фантастика"
        case .tvMovie:
            return "ТВ фильм"
        case .thriller:
            return "Триллер"
        case .war:
            return "Войенный"
        case .western:
            return "Вестерн"
        }
    }
}
