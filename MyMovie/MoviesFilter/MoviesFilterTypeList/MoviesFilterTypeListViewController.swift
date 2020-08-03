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
    func saveDidTap(_ sender: MoviesFilterTypeListViewController)
    func closeDidTap(_ sender: MoviesFilterTypeListViewController)
    func releaseDateDidTap(_ sender: MoviesFilterTypeListViewController)
    func genresDidTap(_ sender: MoviesFilterTypeListViewController)
    func durationDidTap(_ sender: MoviesFilterTypeListViewController)
}

class MoviesFilterTypeListViewController: UITableViewController {
    enum CellType: Int, Equatable {
        case adult = 0
        case voteAverage = 1
        case voteCount = 2
        case releaseDate = 3
        case genres = 4
        case duration = 5
    }
    
    // MARK: - Outlets
    @IBOutlet weak var adultSwitch: UISwitch!
    @IBOutlet weak var voteAverageTextField: UITextField!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    // MARK: - Properties
    private let voteAveragePickerView = UIPickerView()
    
    var viewModel: MoviesFilterTypeListViewModel!
    
    weak var delegate: MoviesFilterTypeListViewControllerDelegate?
    
    static func instantiate(viewModel: MoviesFilterTypeListViewModel) -> MoviesFilterTypeListViewController {
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(self.saveButtonDidTap(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(self.cancelButtonDidTap(_:)))
        
        // tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .systemGray6
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        // adultTableViewCell
        self.adultSwitch.addTarget(self, action: #selector(self.adultSwitchDidChangedValue(_:)), for: .valueChanged)
        
        // voteAverageTableViewCell
        self.voteAveragePickerView.delegate = self
        self.voteAveragePickerView.dataSource = self
        self.voteAverageTextField.inputView = self.voteAveragePickerView
        
        // voteCountTableViewCell
        
        // releaseDateTableViewCell
        
        // genresTableViewCell
        
    }
    
    // MARK: - Actions
    @objc func saveButtonDidTap(_ sender: UIBarButtonItem) {
        self.delegate?.saveDidTap(self)
    }
    
    @objc func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.delegate?.closeDidTap(self)
    }
    
    @objc func adultSwitchDidChangedValue(_ sender: UISwitch) {
        
    }
    
    func voteAverageTableViewCellDidTap(_ sender: UITableViewCell) {
    }
    
    func voteCountTableViewCellDidTap(_ sender: UITableViewCell) {
        
    }
    
    func releasDateTableViewCellDidTap(_ sender: UITableViewCell) {
        
    }
    
    func genresTableViewCellDidTap(_ sender: UITableViewCell) {
        
    }
    
    func durationTableViewCellDidTap(_ sender: UITableViewCell) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellType = CellType(rawValue: indexPath.row), let cell = self.tableView.cellForRow(at: indexPath) {
            switch cellType {
            case .adult: break
            case .voteAverage:
                self.voteAverageTableViewCellDidTap(cell)
            case .voteCount:
                self.voteAverageTableViewCellDidTap(cell)
            case .releaseDate:
                self.releasDateTableViewCellDidTap(cell)
            case .genres:
                self.genresTableViewCellDidTap(cell)
            case .duration:
                self.durationTableViewCellDidTap(cell)
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension MoviesFilterTypeListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView === self.voteAveragePickerView {
            return 2
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === self.voteAveragePickerView {
            if component == 0 {
                return 11
            } else {
                return 11
            }
        } else {
            return 0
        }
    }
}
