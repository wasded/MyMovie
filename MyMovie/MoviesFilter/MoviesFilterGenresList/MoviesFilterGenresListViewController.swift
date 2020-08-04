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
    var viewModel: MoviesFilterGenresListViewModel!
    
    static func instantiate(viewModel: MoviesFilterGenresListViewModel) -> MoviesFilterGenresListViewController {
        let viewController = UIStoryboard.moviesFilterStoryboard.instantiateViewController(withIdentifier: String(describing: MoviesFilterGenresListViewController.self)) as! MoviesFilterGenresListViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.configureInterface()
    }
    
    // MARK: - Methods
    private func configureInterface() {
        
    }
    
    // MARK: - Actions
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MoviesFilterGenresListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
