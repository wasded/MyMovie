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
    
    static func instantiate(viewModel: MovieDetailViewModel, movieID: Int) -> MovieDetailViewController {
        let viewController = UIStoryboard.movieDetailStoryboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
        viewController.viewModel = viewModel
        viewController.movieID = movieID
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInteface()
        self.bindingToProperties()
        self.viewModel.getMovieDetail(movieID: self.movieID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.tintColor = .navigationBarBackButtonColor
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
    
    private func configureInteface() {
        // self
        self.headerHeightContraint.constant = self.headerMaximumHeight
        
        // tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.header.data = MovieDetailHeaderData(posterURL: nil, title: "Название фильма", info: "Самая длинная информация о фильме в две строки")
    }
    
    private func movieDetailModelDidChanged(_ movieDetailModel: MovieDetailModel) {
        self.header.data = movieDetailModel.headerData
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
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
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
