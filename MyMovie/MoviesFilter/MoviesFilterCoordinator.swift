//
//  MoviesFilterCoordinator.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 31.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Resolver

class MoviesFilterCoordinator: NavigationCoordinator {
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - Methods
    override func start(with completion: @escaping () -> Void) {
        super.start(with: completion)
    }
    
    override func prepare() {
        // FIXME: Нужно модель передовать
        let viewController = MoviesFilterListViewController.instantiate(viewModel: MoviesFilterListViewModel(moviesFilterModel: MoviesFilterModel(isAdult: false, voteAverageLte: -1, voteAverageGte: -1, voteCount: .any, releaseDateLte: .any, releaseDateGte: .any)))
        viewController.delegate = self
        self.root(viewController)
        super.prepare()
    }
}

// MARK: - MoviesFilterTypeListViewControllerDelegate
extension MoviesFilterCoordinator: MoviesFilterListViewControllerDelegate {
    func saveDidTap(_ sender: MoviesFilterListViewController) {
        
    }
    
    func closeDidTap(_ sender: MoviesFilterListViewController) {
    }
    
    func genresDidTap(_ sender: MoviesFilterListViewController) {
        // FIXME: Передавать модель
        let viewController = MoviesFilterGenresListViewController.instantiate(viewModel: MoviesFilterGenresListViewModel(selectedGenres: Set()))
        self.show(viewController)
    }
    
    func closeButtonDidTap(_ sender: MoviesFilterListViewController) {
    }
    
    func saveButtonDidTap(_ sender: MoviesFilterListViewController) {
    }
}
