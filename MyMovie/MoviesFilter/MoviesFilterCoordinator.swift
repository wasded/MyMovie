//
//  MoviesFilterCoordinator.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 31.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import Resolver

protocol MoviesFilterCoordinatorDelegate: class {
    func saveButtonDidTap(_ sender: MoviesFilterCoordinator, filterModel: MoviesFilterModel)
    func closeDidTap(_ sender: MoviesFilterCoordinator)
}

class MoviesFilterCoordinator: NavigationCoordinator {
    // MARK: - Properties
    var filterModel: MoviesFilterModel
    
    weak var delegate: MoviesFilterCoordinatorDelegate?

    // MARK: - Init
    init(rootViewController: UINavigationController, filterModel: MoviesFilterModel) {
        self.filterModel = filterModel
        super.init(rootViewController: rootViewController)
    }
    
    // MARK: - Methods
    override func start(with completion: @escaping () -> Void) {
        super.start(with: completion)
    }
    
    override func prepare() {
        // FIXME: Нужно модель передовать
        let viewController = MoviesFilterListViewController.instantiate(viewModel: MoviesFilterListViewModel(moviesFilterModel: self.filterModel))
        viewController.delegate = self
        self.root(viewController)
        super.prepare()
    }
}

// MARK: - MoviesFilterTypeListViewControllerDelegate
extension MoviesFilterCoordinator: MoviesFilterListViewControllerDelegate {
    func saveDidTap(_ sender: MoviesFilterListViewController, filterModel: MoviesFilterModel) {
        self.delegate?.saveButtonDidTap(self, filterModel: filterModel)
    }
    
    func closeDidTap(_ sender: MoviesFilterListViewController) {
        self.delegate?.closeDidTap(self)
    }
    
    func genresDidTap(_ sender: MoviesFilterListViewController, genres: Set<MovieGenre>) {
        // FIXME: Передавать модель
        let viewController = MoviesFilterGenresListViewController.instantiate(viewModel: MoviesFilterGenresListViewModel(selectedGenres: genres))
        viewController.delegate = sender
        self.show(viewController)
    }
}
