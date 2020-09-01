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
import Combine

protocol MoviesListViewControllerDelegate: class {
    func openFilterDidTap(_ sender: MoviesListViewController, filterModel: MoviesFilterModel)
    func openMovieDidTap(_ sender: MoviesListViewController, movieID: Int)
}

class MoviesListViewController: UIViewController {
    enum SortingType: SortingItem, CaseIterable {
        case pupularity
        case releaseDate
        case revenue
        case primaryReleaseDate
        case originalTitle
        case voteAverage
        case voteCount
        
        var text: String {
            switch self {
            case .pupularity:
                return "Популярность"
            case .releaseDate:
                return "Дата релиза"
            case .revenue:
                return "Сборы"
            case .primaryReleaseDate:
                return "Дата основного выпуска"
            case .originalTitle:
                return "Название"
            case .voteAverage:
                return "Оценки"
            case .voteCount:
                return "Колличество оценок"
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
        
    // MARK: - Proprties
    let sortingView = SortingView<SortingType>()
    
    var items: [MovieDiscoverResponse] = [] {
        didSet {
            // FIMXE: Сделать диффы
            if self.items != oldValue {
                self.tableView.reloadData()
            }
        }
    }
    var viewModel: MoviesListViewModel!
    
    weak var delegate: MoviesListViewControllerDelegate?
    
    private var cancellables: Set<AnyCancellable> = []
    
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
        self.delegate?.openFilterDidTap(self, filterModel: self.viewModel.filterModel)
    }
    
    // MARK: - Methods
    private func bindingToProperties() {
        self.viewModel.$discoveredMovies
            .sink { [weak self] (response) in
                self?.items = response
        }
        .store(in: &self.cancellables)
        
        Publishers.CombineLatest(self.sortingView.$selectedSortingType, self.sortingView.$isAscOrder)
            .sink { [weak self] (value) in
                guard let self = self else { return }
                
                let (selectedSortingType, isAscOrder) = value
                
                if let selectedSortingType = selectedSortingType {
                    let movieSortingType: MovieSortingType
                    switch selectedSortingType {
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
        .store(in: &self.cancellables)
    }
    
    private func configureInterface() {
        // navigationBar
        self.title = "Фильмы"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profileTabBar"), style: .plain, target: self, action: #selector(self.filterButtonDidTap(_:)))

        // sortingView
        let sortingViewHeight: CGFloat = 58
        self.sortingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: sortingViewHeight)
        self.sortingView.sortingTypes = SortingType.allCases
        
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
        
        let urlPoster: URL?
        if let posterPath = data.posterPath {
            urlPoster = APIHelper.getPosterURL(posterType: .custom(200), posterPath: posterPath)
        } else {
            urlPoster = nil
        }
        
        cell.data = MovieTableViewData(urlPoster: urlPoster, titleLabel: data.title, releaseDate: data.releaseDate, genres: data.genreIDS.map({ $0.name }), voteAverage: data.voteAverage, description: data.overview)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.items[indexPath.row]
        self.delegate?.openMovieDidTap(self, movieID: movie.id)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
