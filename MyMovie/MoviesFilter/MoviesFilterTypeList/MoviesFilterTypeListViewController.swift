//
//  MoviesFilterTypeListViewController.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 31.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import UIKit

// Можно было упростить и использовать статику, но мы легких путей не ищем)))
class MoviesFilterTypeListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: MoviesFilterViewModel!
    
    static func instantiate(viewModel: MoviesFilterViewModel) -> MoviesFilterTypeListViewController {
        let viewController = UIStoryboard.moviesListStoryboard.instantiateViewController(withIdentifier: String(describing: MoviesFilterTypeListViewController.self)) as! MoviesFilterTypeListViewController
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    private func configureInterface() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MoviesFilterTypeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
