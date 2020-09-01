//
//  MovieDetailViewController.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 06.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    // MARK: - Outelts
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var descriptionMovieLabel: UILabel!
    
    // MARK: - Proprties
    var movieID: Int!
    var viewModel: MovieDetailViewModel!
    var movieDetail: MoviesDetailResponse? {
        didSet {
            if let movieDetail = self.movieDetail {
                self.movieDetailDidChanged(movieDetail)
            }
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    static func instantiate(viewModel: MovieDetailViewModel, movieID: Int) -> MovieDetailViewController {
        let viewController = UIStoryboard.movieDetailStoryboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
        viewController.viewModel = viewModel
        viewController.movieID = movieID
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInteface()
        self.bindingToProperties()
    }
    
    // MARK: - Methods
    private func bindingToProperties() {
        self.viewModel.getMovieDetail(movieID: self.movieID)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.handleError(error)
                }
            }) { (response) in
                self.movieDetail = response
        }
        .store(in: &self.cancellables)
    }
    
    private func configureInteface() {
        
    }
    
    private func movieDetailDidChanged(_ movieDetail: MoviesDetailResponse) {
        
    }

    private func handleError(_ error: Error) {
        
    }
    
    // MARK: - Actions
}
