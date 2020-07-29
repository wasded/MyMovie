//
//  MoviesListViewModel.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 29.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Combine
import Resolver

class MoviesListViewModel {
    @Injected var backendController: BackendDiscoverController
    
    init(backendController: BackendDiscoverController) {
        self.backendController = backendController
    }
}
