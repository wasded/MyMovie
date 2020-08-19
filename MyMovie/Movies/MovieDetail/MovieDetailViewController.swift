//
//  MovieDetailViewController.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 06.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {
    // MARK: - Outelts
    
    // MARK: - Proprties
    var viewModel: MovieDetailViewModel!
    
    static func instantiate(viewModel: MovieDetailViewModel) -> MovieDetailViewController {
        let viewController = UIStoryboard.moviesListStoryboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInteface()
    }
    
    // MARK: - Methods
    private func configureInteface() {
        
    }
    
    // MARK: - Actions
}
