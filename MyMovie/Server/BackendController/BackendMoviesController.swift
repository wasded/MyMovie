//
//  BackendMoviesController.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 29.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Combine

protocol BackendMoviesController: class {
    func getDetail(movieID: Int, language: String, appendToResponse: String?) -> AnyPublisher<MoviesDetailResponse, Error>
}
