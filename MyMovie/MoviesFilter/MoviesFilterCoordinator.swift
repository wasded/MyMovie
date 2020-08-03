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
        let viewController = MoviesFilterListViewController.instantiate(viewModel: MoviesFilterListViewModel(moviesFilterModel: MoviesFilterModel(voteAverageLte: .any, voteAverageGte: .any)))
        self.root(viewController)
        super.prepare()
    }
}

// MARK: - MoviesFilterTypeListViewControllerDelegate
extension MoviesFilterCoordinator: MoviesFilterListViewControllerDelegate {
    func durationDidTap(_ sender: MoviesFilterListViewController) {
    }
    
    func saveDidTap(_ sender: MoviesFilterListViewController) {
    }
    
    func closeDidTap(_ sender: MoviesFilterListViewController) {
    }
    
    func releaseDateDidTap(_ sender: MoviesFilterListViewController) {
    }
    
    func genresDidTap(_ sender: MoviesFilterListViewController) {
    }
    
    func closeButtonDidTap(_ sender: MoviesFilterListViewController) {
    }
    
    func saveButtonDidTap(_ sender: MoviesFilterListViewController) {
    }
}
