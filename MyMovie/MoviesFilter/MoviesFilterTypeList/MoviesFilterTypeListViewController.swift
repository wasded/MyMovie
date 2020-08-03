//
//  MoviesFilterTypeListViewController.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 31.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol MoviesFilterTypeListViewControllerDelegate: class {
    func saveButtonDidTap(_ sender: MoviesFilterTypeListViewController)
    func closeButtonDidTap(_ sender: MoviesFilterTypeListViewController)
}

// Можно было упростить и использовать статику, но мы легких путей не ищем)))
class MoviesFilterTypeListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: MoviesFilterViewModel!
    
    weak var delegate: MoviesFilterTypeListViewControllerDelegate?
    
    static func instantiate(viewModel: MoviesFilterViewModel) -> MoviesFilterTypeListViewController {
        let viewController = UIStoryboard.moviesFilterStoryboard.instantiateViewController(withIdentifier: String(describing: MoviesFilterTypeListViewController.self)) as! MoviesFilterTypeListViewController
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInterface()
    }
    
    // MARK: - Methods
    private func configureInterface() {
        // self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveButtonDidTap(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.cacnelButtonDidTap(_:)))
        
        // tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    @objc func saveButtonDidTap(_ sender: UIBarButtonItem) {
        self.delegate?.saveButtonDidTap(self)
    }
    
    @objc func cacnelButtonDidTap(_ sender: UIBarButtonItem) {
        self.delegate?.closeButtonDidTap(self)
    }
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
