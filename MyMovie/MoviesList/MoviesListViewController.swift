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
        self.sortingView.frame = CGRect(x: 0, y: 0, width: 0, height: 42)
        self.sortingView.delegate = self
        //self.collectionView.asssignCustomHeaderView(headerView: self.sortingView)
        let height = self.sortingView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.sortingView.frame = CGRect(x: 0, y: -height + self.collectionView.contentInset.top - 8, width: self.collectionView.frame.width, height: height)
        self.collectionView.addSubview(self.sortingView)
        self.collectionView.contentInset = UIEdgeInsets(top: height + 8 , left: 8, bottom: self.collectionView.contentInset.bottom, right: 8)

        // collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CustomCell.self, forCellWithReuseIdentifier: String(describing: CustomCell.self))
        
        
//        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(
//        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UIcollection
extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CustomCell.self), for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

class CustomCell: UICollectionViewCell {
    
}

extension UICollectionView {
    var CustomCollectionViewHeaderTag: Int {
        return 12345678
    }
    
    var currentCustomHeaderView: UIView? {
        return self.viewWithTag(CustomCollectionViewHeaderTag)
    }

    func asssignCustomHeaderView(headerView: UIView, sideMarginInsets: CGFloat = 0) {
        guard self.viewWithTag(CustomCollectionViewHeaderTag) == nil else {
            return
        }
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        headerView.frame = CGRect(x: sideMarginInsets, y: -height + self.contentInset.top, width: self.frame.width - (2 * sideMarginInsets), height: height)
        headerView.tag = CustomCollectionViewHeaderTag
        self.addSubview(headerView)
        self.contentInset = UIEdgeInsets(top: height, left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.right)
    }

    func removeCustomHeaderView() {
        if let customHeaderView = self.viewWithTag(CustomCollectionViewHeaderTag) {
            let headerHeight = customHeaderView.frame.height
            customHeaderView.removeFromSuperview()
            self.contentInset = UIEdgeInsets(top: self.contentInset.top - headerHeight, left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.right)
        }
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
            movieSortingType = isAscOrder ? .voteCountAsc : .voteAverageDesc
        }
    }
    // call viewModel
    
}
