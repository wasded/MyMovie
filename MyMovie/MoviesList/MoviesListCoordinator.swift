//
//  MovieListCoordinator.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit
import Resolver

class MoviesListCoordinator: NavigationCoordinator {
    // MARK: - Proprties
    var moviesListViewController: MoviesListViewController

    // MARK: Init
    override init(rootViewController: UINavigationController?) {
        self.moviesListViewController = MoviesListViewController.instantiate(viewModel: MoviesListViewModel(backendController: Resolver.resolve()))
        
        super.init(rootViewController: rootViewController)
    }
    
    // MARK: - Methods
    override func start(with completion: @escaping () -> Void) {
        super.start(with: completion)
    }
    
    override func prepare() {
        self.moviesListViewController.delegate = self
        self.root(self.moviesListViewController)
        super.prepare()
    }
}

// MARK: - MoviesFilterCoordinatorDelegate
extension MoviesListCoordinator: MoviesFilterCoordinatorDelegate {
    func closeDidTap(_ sender: MoviesFilterCoordinator) {
        self.dismiss {
            self.stopChild(coordinator: sender) {
            }
        }
    }
    
    func saveButtonDidTap(_ sender: MoviesFilterCoordinator, filterModel: MoviesFilterModel) {
        self.dismiss {
            self.stopChild(coordinator: sender) {
                self.moviesListViewController.viewModel.filterModel = filterModel
            }
        }
    }
}

// MARK: - MoviesListViewControllerDelegate
extension MoviesListCoordinator: MoviesListViewControllerDelegate {
    func openFilterDidTap(_ sender: MoviesListViewController, filterModel: MoviesFilterModel) {
        let viewController = UINavigationController()
        let coordinator = MoviesFilterCoordinator(rootViewController: viewController, filterModel: filterModel)
        coordinator.prepare()
        coordinator.delegate = self
        self.startChild(coordinator: coordinator)
        self.present(viewController)
    }
}
