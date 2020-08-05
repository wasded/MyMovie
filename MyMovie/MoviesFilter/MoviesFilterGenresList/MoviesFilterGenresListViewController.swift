//
//  MoviesFilterGenresList.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 04.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit
import Combine

protocol MoviesFilterGenresListViewControllerDelegate: class {
    func selectedGenresDidChanged(_ genres: Set<MovieGenre>)
}

class MoviesFilterGenresListViewController: UIViewController {
    enum SortingType: SortingItem, CaseIterable {
        case popularity
        case alphabetically
        
        var text: String {
            switch self {
            case .popularity:
                return "Популярность"
            case .alphabetically:
                return "По алфавиту"
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let sortingView = SortingView<SortingType>()
    
    var items = [MovieGenreTableViewCellData]() {
        didSet {
            self.itemsDidChanged(oldItems: oldValue, newItems: self.items)
        }
    }
    
    var viewModel: MoviesFilterGenresListViewModel!
    
    weak var delegate: MoviesFilterGenresListViewControllerDelegate?
    
    private var cancellables: Set<AnyCancellable> = []
    
    static func instantiate(viewModel: MoviesFilterGenresListViewModel) -> MoviesFilterGenresListViewController {
        let viewController = UIStoryboard.moviesFilterStoryboard.instantiateViewController(withIdentifier: String(describing: MoviesFilterGenresListViewController.self)) as! MoviesFilterGenresListViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCells()
        self.configureInterface()
        
        self.bindingToProperties()
    }
    
    // MARK: - Methods
    private func configureInterface() {
        // self
        self.title = "Жанры"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(self.clearGenresButtonDidTap(_:)))
        
        // sortingView
        let sortingViewHeight: CGFloat = 58
        self.sortingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: sortingViewHeight)
        self.sortingView.sortingTypes = SortingType.allCases
        
        // tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = self.sortingView
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    private func registerCells() {
        self.tableView.register(MovieGenreTableViewCell.self, forCellReuseIdentifier: String(describing: MovieGenreTableViewCell.self))
    }
    
    private func bindingToProperties() {
        self.viewModel.$items
            .sink { [weak self] (value) in
                self?.items = value
        }
        .store(in: &self.cancellables)
        
        self.viewModel.$selectedGenres
            .sink { [weak self] (value) in
                guard let self = self else { return }
                self.navigationItem.rightBarButtonItem?.isEnabled = !value.isEmpty
                self.delegate?.selectedGenresDidChanged(value)
        }
        .store(in: &self.cancellables)
        
        Publishers.CombineLatest(self.sortingView.$selectedSortingType, self.sortingView.$isAscOrder)
            .dropFirst()
            .sink { [weak self] (value) in
                guard let self = self else { return }
                let isAscOrder = value.1
                let selectedSortingType = value.0
                
                if let selectedSortingType = selectedSortingType {
                    let value: MoviesFilterGenresListViewModel.SortingType
                    switch selectedSortingType {
                    case .popularity:
                        value = isAscOrder ? .popularityAsc : .popularityDesc
                    case .alphabetically:
                        value = isAscOrder ? .alphabeticallyAsc : .alphabeticallyDesc
                    }
                    
                    self.viewModel.sortingType = value
                }
        }
        .store(in: &self.cancellables)
    }
    
    // FIXME: В iOS13 вроде как появился свой механизм дифов, изучить и переделать на него
    private func itemsDidChanged(oldItems: [MovieGenreTableViewCellData], newItems: [MovieGenreTableViewCellData]) {
        if oldItems.isEmpty {
            self.tableView.reloadData()
            return
        }
        
        var deletedItems = Set<IndexPath>()
        var addedItems = Set<IndexPath>()
        var changedItems = Array<(indexPath: IndexPath, newValue: MovieGenreTableViewCellData)>() // чтобы лишний раз не обращаться к массиву
        
        // Так как колличество элементов у нас всегда одно, то такого простого диффа вполне хватит
        for oldItem in oldItems.enumerated() {
            if let newItem = newItems.enumerated().first(where: { $0.element.type == oldItem.element.type }) {
                if newItem.offset != oldItem.offset {
                    deletedItems.insert(IndexPath(item: oldItem.offset, section: 0))
                    addedItems.insert(IndexPath(item: newItem.offset, section: 0))
                } else if newItem.element != oldItem.element {
                    changedItems.append((IndexPath(item: oldItem.offset, section: 0), newItem.element))
                }
            }
        }
        
        self.tableView.beginUpdates()
        
        for item in changedItems {
            if let cell = self.tableView.cellForRow(at: item.indexPath) as? MovieGenreTableViewCell {
                cell.data = item.newValue
            }
        }
        
        self.tableView.deleteRows(at: Array(deletedItems), with: .left)
        self.tableView.insertRows(at: Array(addedItems), with: .left)
        
        self.tableView.endUpdates()
    }
    
    // MARK: - Actions
    @objc func clearGenresButtonDidTap(_ sender: UIBarButtonItem) {
        self.viewModel.selectedGenres.removeAll()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MoviesFilterGenresListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: MovieGenreTableViewCell.self), for: indexPath) as! MovieGenreTableViewCell
        cell.data = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        if self.viewModel.selectedGenres.contains(item.type) {
            self.viewModel.selectedGenres.remove(item.type)
        } else {
            self.viewModel.selectedGenres.insert(item.type)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
//
//extension MoviesFilterGenresListViewController: SortingGenresViewDelegate {
//    func valueChanged(sortingType: SortingGenresView.SortingType, isAscOrder: Bool) {
//        let value: MoviesFilterGenresListViewModel.SortingType
//        switch sortingType {
//        case .popularity:
//            value = isAscOrder ? .popularityAsc : .popularityDesc
//        case .alphabetically:
//            value = isAscOrder ? .alphabeticallyAsc : .alphabeticallyDesc
//        }
//
//        self.viewModel.sortingType = value
//    }
//
//
//}
