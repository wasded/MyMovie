//
//  MovieDetailViewController.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 06.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit
import Combine
import SkeletonView

class MovieDetailViewController: UIViewController {
    // MARK: - Outelts
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var header: MovieDetailHeaderView!
    
    // MARK: - Proprties
    var movieID: Int!
    var viewModel: MovieDetailViewModel!
    var movieDetailModel: MovieDetailModel? {
        didSet {
            if let movieDetail = self.movieDetailModel {
                self.movieDetailModelDidChanged(movieDetail)
            }
        }
    }
    
    private let headerMaximumHeight: CGFloat = 375.0
    private let headerMinimumHeight: CGFloat = 200.0
    private var cancellables: Set<AnyCancellable> = []
    
    static func instantiate(viewModel: MovieDetailViewModel) -> MovieDetailViewController {
        let viewController = UIStoryboard.movieDetailStoryboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInteface()
        self.registerCells()
        self.bindingToProperties()
        self.viewModel.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.tintColor = .mainTextColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.view.backgroundColor = nil
        self.navigationController?.navigationBar.tintColor = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Methods
    private func bindingToProperties() {
        self.viewModel.$movieDetailModel
            .sink(receiveCompletion: { (_) in
            }) { (model) in
                self.movieDetailModel = model
        }
        .store(in: &self.cancellables)
    }
    
    private func registerCells() {
        self.tableView.register(MovieDetailActionsCell.self, forCellReuseIdentifier: String(describing: MovieDetailActionsCell.self))
        self.tableView.register(MovieDetailDescriptionCell.self, forCellReuseIdentifier: String(describing: MovieDetailDescriptionCell.self))
        self.tableView.register(MovieDetailCrewCell.self, forCellReuseIdentifier: String(describing: MovieDetailCrewCell.self))
        
    }
    
    private func configureInteface() {
        // self
        self.headerHeightContraint.constant = self.headerMaximumHeight
        
        // tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView()
    }
    
    private func movieDetailModelDidChanged(_ movieDetailModel: MovieDetailModel) {
        self.header.data = movieDetailModel.headerData
        self.tableView.reloadData()
    }

    private func handleError(_ error: Error) {
        
    }
    
    private func setMaximumHeaderSize() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.headerHeightContraint.constant = self.headerMaximumHeight
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Actions
    @objc func favoriteButtonDidTap() {
    }
    
    @objc func watchLaterButtonDidTap() {
    }
    
    @objc func expandButtonDidTap() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MovieDetailViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.movieDetailModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieDetailModel?.sections[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = self.movieDetailModel?.sections[indexPath.section].items[indexPath.row] else { return UITableViewCell() }
        
        if let data = data as? MovieDetailActionsCellData {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: MovieDetailActionsCell.self), for: indexPath) as! MovieDetailActionsCell
            cell.watchLaterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.watchLaterButtonDidTap)))
            cell.favoriteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favoriteButtonDidTap)))
            cell.selectionStyle = .none
            cell.data = data
            return cell
        } else if let data = data as? MovieDetailDescriptionCellData {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: MovieDetailDescriptionCell.self), for: indexPath) as! MovieDetailDescriptionCell
            cell.expandButton.addTarget(self, action: #selector(self.expandButtonDidTap), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.data = data
            return cell
        } else if let data = data as? MovieDetailCrewCellData {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: String(describing: MovieDetailCrewCell.self), for: indexPath) as! MovieDetailCrewCell
            cell.selectionStyle = .none
            cell.data = data
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 0
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "asdsad"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.changeHeaderSize(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightContraint.constant > self.headerMaximumHeight {
            self.setMaximumHeaderSize()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightContraint.constant > self.headerMaximumHeight {
            self.setMaximumHeaderSize()
        }
    }
    
    func changeHeaderSize(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            let devider: CGFloat
            if self.headerHeightContraint.constant > self.headerMaximumHeight {
                devider = 4
            } else {
                devider = 1
            }
            self.headerHeightContraint.constant += abs(scrollView.contentOffset.y/devider)
            scrollView.contentOffset.y = 0
        } else if scrollView.contentOffset.y > 0, self.headerHeightContraint.constant > self.headerMinimumHeight {
            self.headerHeightContraint.constant -= abs(scrollView.contentOffset.y)
            scrollView.contentOffset.y = 0
        }
        
        if self.headerHeightContraint.constant < self.headerMinimumHeight {
            self.headerHeightContraint.constant = self.headerMinimumHeight
        }
    }
}
