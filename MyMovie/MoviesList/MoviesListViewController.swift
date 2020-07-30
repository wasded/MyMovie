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
    @IBOutlet weak var collectionView: UICollectionView!
        
    // MARK: - Proprties
    private lazy var sortingView = SortingView()
    var items: [MovieDiscover] = [] {
        didSet {
            if self.items != oldValue {
                self.collectionView.reloadData()
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
        
        self.viewModel.$wasFirstLoad
            .sink { (value) in
                if value {
                    self.collectionView.hideSkeleton()
                }
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
        let leftEdgeInsent: CGFloat = 8
        let rightEdgeInsent: CGFloat = 8
        
        self.sortingView.frame = CGRect(x: 0, y: 0, width: 0, height: sortingViewHeight)
        self.sortingView.delegate = self
        
        self.sortingView.frame = CGRect(x: 0, y: -sortingViewHeight + self.collectionView.contentInset.top - 8, width: self.view.frame.width, height: sortingViewHeight)
        self.collectionView.addSubview(self.sortingView)

        // collectionView
        self.collectionView.isSkeletonable = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
        self.collectionView.showAnimatedGradientSkeleton()
        self.collectionView.prepareSkeleton { (done) in
        }
        self.collectionView.contentInset = UIEdgeInsets(top: sortingViewHeight + 8 , left: leftEdgeInsent, bottom: self.collectionView.contentInset.bottom, right: rightEdgeInsent)
    }
    
    private func needLoadNewMovies(indexPath: IndexPath) -> Bool {
        return self.items.count - 3 == indexPath.row
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UIcollection
extension MoviesListViewController: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as! MovieCollectionViewCell
        
        if self.needLoadNewMovies(indexPath: indexPath) {
            self.viewModel.currentPage += 1
        }
        
        let data = self.items[indexPath.row]
        cell.data = MovieCollectionViewData(urlPoster: data.getPosterURL(posterType: .custom(200)), titleLabel: data.title)
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: MovieCollectionViewCell.self)
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
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
