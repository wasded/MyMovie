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
    enum SortType: CaseIterable {
        case popularity
        case releaseDate
        case voteAverage
        case voteCount
        
        func getDescription() -> String {
            switch self {
            case .popularity:
                return "Популярные"
            case .releaseDate:
                return "Дата выхода"
            case .voteAverage:
                return "Топ"
            case .voteCount:
                return "Оценки"
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Proprties
    var soryType: SortType = .popularity
    
    private lazy var segmentedControl: UISegmentedControl = {
        return UISegmentedControl()
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
        // navigation bar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Фильмы"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profileTabBar"), style: .plain, target: self, action: #selector(self.filterButtonDidTap(_:)))

        
        // segmented controll
        for index in 0..<SortType.allCases.count {
            self.segmentedControl.insertSegment(withTitle: SortType.allCases[index].getDescription(), at: index, animated: false)
        }
    }
}
