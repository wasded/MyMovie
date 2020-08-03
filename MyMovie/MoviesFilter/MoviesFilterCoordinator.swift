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
        let viewController = MoviesFilterTypeListViewController.instantiate(viewModel: MoviesFilterViewModel())
        self.root(viewController)
        super.prepare()
    }
}

// MARK: - MoviesFilterTypeListViewControllerDelegate
extension MoviesFilterCoordinator: MoviesFilterTypeListViewControllerDelegate {
    func saveButtonDidTap(_ sender: MoviesFilterTypeListViewController) {
    }
}
