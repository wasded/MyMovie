//
//  MoviesFilterGenresList.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 04.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

class MoviesFilterGenresListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var items = [MovieGenreTableViewCellData]() {
        didSet {
            self.itemsDidChanged(oldItems: oldValue, newItems: self.items)
        }
    }
    
    var viewModel: MoviesFilterGenresListViewModel!
    
    static func instantiate(viewModel: MoviesFilterGenresListViewModel) -> MoviesFilterGenresListViewController {
        let viewController = UIStoryboard.moviesFilterStoryboard.instantiateViewController(withIdentifier: String(describing: MoviesFilterGenresListViewController.self)) as! MoviesFilterGenresListViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.bindingToProperties()
        self.registerCells()
        
        self.configureInterface()
    }
    
    // MARK: - Methods
    private func configureInterface() {
        // self
        
        // tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
    }
    
    private func registerCells() {
        self.tableView.register(MovieGenreTableViewCell.self, forCellReuseIdentifier: String(describing: MovieGenreTableViewCell.self))
    }
    
    private func bindingToProperties() {
        self.viewModel.$items
            .sink { (items) in
                self.items = items
        }
        .store(in: &self.viewModel.cancellables)
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
