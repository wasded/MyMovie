//
//  MovieListViewController.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import UIKit
import Foundation

class MoviesListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Proprties
    private lazy var sortingView: SortingView = {
        return SortingView()
    }()
    
    static func instantiate() -> MoviesListViewController {
        let viewController = UIStoryboard.moviesListStoryboard.instantiateViewController(withIdentifier: String(describing: MoviesListViewController.self)) as! MoviesListViewController
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInterface()
    }
    
    // MARK: - Actions
    @objc func filterButtonDidTap(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Methods
    private func configureInterface() {
        // navigationBar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Фильмы"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profileTabBar"), style: .plain, target: self, action: #selector(self.filterButtonDidTap(_:)))

        // sortingView
        let sortingViewHeight: CGFloat = 42
        self.sortingView.frame = CGRect(x: 0, y: 0, width: 0, height: sortingViewHeight)
        self.sortingView.delegate = self
        
        self.sortingView.frame = CGRect(x: 0, y: -sortingViewHeight + self.collectionView.contentInset.top - 8, width: self.collectionView.frame.width, height: sortingViewHeight)
        self.collectionView.addSubview(self.sortingView)

        // collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: sortingViewHeight + 8 , left: 8, bottom: self.collectionView.contentInset.bottom, right: 8)
        self.collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UIcollection
extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as! MovieCollectionViewCell
        cell.layer.cornerRadius = 8
        cell.data = MovieCollectionViewData(posterImage: "https://upload.wikimedia.org/wikipedia/ru/thumb/6/68/Trainspotting-poster.jpg/203px-Trainspotting-poster.jpg", titleLabel: "jooapsdpapdapsdpaspdpadp")
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }
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
            movieSortingType = isAscOrder ? .voteCountAsc : .voteAverageDesc
        }
    }
    // call viewModel
    
}
