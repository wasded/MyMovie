//
//  MovieListCoordinator.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

class MovieListCoordinator: NavigationCoordinator {
    // MARK: - Proprties
    
    // MARK: Init
    
    // MARK: - Methods
    override func start(with completion: @escaping () -> Void) {
        super.start(with: completion)
    }
    
    override func prepare() {
        let viewController = UIStoryboard.movieListStoryboard.instantiateViewController(withIdentifier: "MovieList")
        self.root(viewController)
        super.prepare()
    }
}
