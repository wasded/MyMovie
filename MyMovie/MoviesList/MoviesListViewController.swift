//
//  MovieListViewController.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import UIKit
import Foundation
import SkeletonView
import SwiftUI

class MoviesListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
        
    // MARK: - Proprties
    private lazy var sortingView = SortingView()
    var items: [MovieDiscover] = [] {
        didSet {
            if self.items != oldValue {
                self.tableView.reloadData()
            }
        }
    }
    
    var viewModel: MoviesListViewModel!
    
    static func instantiate(viewModel: MoviesListViewModel) -> MoviesListViewController {
        let viewController = UIStoryboard.moviesListStoryboard.instantiateViewController(withIdentifier: String(describing: MoviesListViewController.self)) as! MoviesListViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInterface()
        self.bindingToProperties()
        self.viewModel.start()
    }
    
    // MARK: - Actions
    @objc func filterButtonDidTap(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Methods
    private func bindingToProperties() {
        self.viewModel.$discoveredMovies
            .sink { (response) in
                self.items = response
        }
        .store(in: &self.viewModel.cancellables)
    }
    
    private func configureInterface() {
        // navigationBar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Фильмы"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profileTabBar"), style: .plain, target: self, action: #selector(self.filterButtonDidTap(_:)))

        // sortingView
        let sortingViewHeight: CGFloat = 42
        self.sortingView.delegate = self
        self.sortingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: sortingViewHeight)
        
        // collectionView
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.bouncesZoom = false
        self.tableView.isSkeletonable = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = self.sortingView
        self.tableView.estimatedRowHeight = 216
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: String(describing: MovieTableViewCell.self))
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private func needLoadNewMovies(indexPath: IndexPath) -> Bool {
        return self.items.count - 3 == indexPath.row
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UIcollection
extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as! MovieTableViewCell
        
        if self.needLoadNewMovies(indexPath: indexPath) {
            self.viewModel.currentPage += 1
        }
        
        let data = self.items[indexPath.row]
        cell.data = MovieTableViewData(urlPoster: data.getPosterURL(posterType: .custom(200)), titleLabel: data.title, releaseDate: data.releaseDate, genres: data.genreIDS.map({ $0.name }), voteAverage: data.voteAverage, description: data.overview)
        return cell
    }
}

// MARK: - SortingViewDelegate
extension MoviesListViewController: SortingViewDelegate {
    func valueChanged(sortingType: SortingView.SortingType, isAscOrder: Bool) {
        let movieSortingType: MovieSortingType
        switch sortingType {
        case .pupularity:
            movieSortingType = isAscOrder ? .popularityAsc : .popularityDesc
        case .releaseDate:
            movieSortingType = isAscOrder ? .releaseDateAsc : .releaseDateDesc
        case .revenue:
            movieSortingType = isAscOrder ? .revenueAsc : .revenueDesc
        case .primaryReleaseDate:
            movieSortingType = isAscOrder ? .primaryReleaseDateAsc : .primaryReleaseDateDesc
        case .originalTitle:
            movieSortingType = isAscOrder ? .originalTitleAsc : .originalTitleDesc
        case .voteAverage:
            movieSortingType = isAscOrder ? .voteAverageAsc : .voteAverageDesc
        case .voteCount:
            movieSortingType = isAscOrder ? .voteCountAsc : .voteCountDesc
        }
        
        self.viewModel.sortType = movieSortingType
    }
}
