//
//  MoviesFilterListViewController.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 31.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import UIKit
import Combine

// MARK: - Delegate
protocol MoviesFilterListViewControllerDelegate: class {
    func saveDidTap(_ sender: MoviesFilterListViewController, filterModel: MoviesFilterModel)
    func closeDidTap(_ sender: MoviesFilterListViewController)
    func genresDidTap(_ sender: MoviesFilterListViewController, genres: Set<MovieGenre>)
}

class MoviesFilterListViewController: UITableViewController {
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
    @IBOutlet weak var voteCountTextField: UITextField!
    @IBOutlet weak var releaseDateTextField: UITextField!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var durationTextField: UITextField!
    
    // MARK: - Properties
    // Можно было использовать один пикер, но проще сделать несколько, так как с одним можно багов наловить
    let voteAveragePickerView = UIPickerView()
    let voteCountPickerView = UIPickerView()
    let releaseDatePickerView = UIPickerView()
    let durationPickerView = UIPickerView()
    let keyboardToolBar = MoviesFilterListKeyboardToolBar()
    
    var viewModel: MoviesFilterListViewModel!
    
    weak var delegate: MoviesFilterListViewControllerDelegate?
    
    private(set) var filtredVoteAveragePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>](), maximum: [MoviesFilterListPickerData<MoviesFilterVoteAverage>]())
    private(set) var filtredReleaseDatePickerViewData = (minimum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>](), maximum: [MoviesFilterListPickerData<MoviesFilterReleaseDate>]())
    
    private var selectedCell: CellType?
    private var cancellables: Set<AnyCancellable> = []
    
    static func instantiate(viewModel: MoviesFilterListViewModel) -> MoviesFilterListViewController {
        let viewController = UIStoryboard.moviesFilterStoryboard.instantiateViewController(withIdentifier: String(describing: MoviesFilterListViewController.self)) as! MoviesFilterListViewController
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.bindingToProperties()
        
        self.configureInterface()
    }
    
    // MARK: - Methods
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //            let bottomInsent = keyboardFrame.size.height
            //            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInsent, right: 0)
            //            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            //            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }
        self.disableAllTextFields()
    }
    
    // FIXME: Придумать способ получше
    private func disableAllTextFields() {
        self.voteAverageTextField.isEnabled = false
        self.voteCountTextField.isEnabled = false
        self.releaseDateTextField.isEnabled = false
        self.durationTextField.isEnabled = false
    }
    
    private func bindingToProperties() {
        self.viewModel.$voteAverageText
            .sink { [weak self] (value) in
                guard let self = self else { return }
                self.voteAverageTextField.text = value
        }
        .store(in: &self.cancellables)
        
        self.viewModel.$filtredVoteAveragePickerViewData
            .sink(receiveValue: { [weak self] (value) in
                guard let self = self else { return }
                self.filtredVoteAveragePickerViewData = value
                self.voteAveragePickerView.reloadAllComponents()
            })
            .store(in: &self.cancellables)
        
        self.viewModel.$voteCountText
            .sink { [weak self] (value) in
                guard let self = self else { return }
                self.voteCountTextField.text = value
        }
        .store(in: &self.cancellables)
        
        self.viewModel.$filtredReleaseDatePickerViewData
            .sink { [weak self] (value) in
                guard let self = self else { return }
                self.filtredReleaseDatePickerViewData = value
                self.releaseDatePickerView.reloadAllComponents()
        }
        .store(in: &self.cancellables)
        
        self.viewModel.$releaseDateText
            .sink { [weak self] (value) in
                guard let self = self else { return }
                self.releaseDateTextField.text = value
        }
        .store(in: &self.cancellables)
        
        self.viewModel.$durationText
            .sink { [weak self] (value) in
                guard let self = self else { return }
                self.durationTextField.text = value
        }
        .store(in: &self.cancellables)
        
        self.viewModel.$genresText
            .sink { [weak self](value) in
                guard let self = self else { return }
                self.genresLabel.text = value
        }
        .store(in: &self.cancellables)
    }
    
    private func configureInterface() {
        // self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(self.saveButtonDidTap(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(self.cancelButtonDidTap(_:)))
        self.title = "Фильтры"
        
        // tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .systemGray6
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        // keyboardToolBar
        self.keyboardToolBar.closeButton.action = #selector(self.closeKeyboardButtonDidTap(_:))
        
        // adultTableViewCell
        self.adultSwitch.isOn = self.viewModel.filterModel.isAdult
        self.adultSwitch.addTarget(self, action: #selector(self.adultSwitchDidChangedValue(_:)), for: .valueChanged)
        
        // voteAverageTableViewCell
        self.voteAveragePickerView.delegate = self
        self.voteAveragePickerView.dataSource = self
        self.voteAverageTextField.inputView = self.voteAveragePickerView
        self.voteAverageTextField.inputAccessoryView = self.keyboardToolBar
        
        // voteCountTableViewCell
        self.voteCountPickerView.delegate = self
        self.voteCountPickerView.dataSource = self
        self.voteCountTextField.inputView = self.voteCountPickerView
        self.voteCountTextField.inputAccessoryView = self.keyboardToolBar
        
        // releaseDateTableViewCell
        self.releaseDatePickerView.delegate = self
        self.releaseDatePickerView.dataSource = self
        self.releaseDateTextField.inputView = self.releaseDatePickerView
        self.releaseDateTextField.inputAccessoryView = self.keyboardToolBar
        
        // durationTableViewCell
        self.durationPickerView.delegate = self
        self.durationPickerView.dataSource = self
        self.durationTextField.inputView = self.durationPickerView
        self.durationTextField.inputAccessoryView = self.keyboardToolBar
        
        
        self.disableAllTextFields()
    }
    
    // MARK: - Actions
    @objc func saveButtonDidTap(_ sender: UIBarButtonItem) {
        self.delegate?.saveDidTap(self, filterModel: self.viewModel.filterModel)
    }
    
    @objc func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        self.delegate?.closeDidTap(self)
    }
    
    @objc func adultSwitchDidChangedValue(_ sender: UISwitch) {
        self.viewModel.isAdultDidChanged(sender.isOn)
    }
    
    func voteAverageTableViewCellDidTap(_ sender: UITableViewCell) {
        self.voteAverageTextField.isEnabled = true
        self.voteAverageTextField.becomeFirstResponder()
    }
    
    func voteCountTableViewCellDidTap(_ sender: UITableViewCell) {
        self.voteCountTextField.isEnabled = true
        self.voteCountTextField.becomeFirstResponder()
    }
    
    func releasDateTableViewCellDidTap(_ sender: UITableViewCell) {
        self.releaseDateTextField.isEnabled = true
        self.releaseDateTextField.becomeFirstResponder()
    }
    
    func genresTableViewCellDidTap(_ sender: UITableViewCell) {
        self.delegate?.genresDidTap(self, genres: self.viewModel.filterModel.genres)
    }
    
    func durationTableViewCellDidTap(_ sender: UITableViewCell) {
        self.durationTextField.isEnabled = true
        self.durationTextField.becomeFirstResponder()
    }
    
    @objc func closeKeyboardButtonDidTap(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.disableAllTextFields()
        
        if let cellType = CellType(rawValue: indexPath.row), let cell = self.tableView.cellForRow(at: indexPath) {
            switch cellType {
            case .adult: break
            case .voteAverage:
                self.voteAverageTableViewCellDidTap(cell)
            case .voteCount:
                self.voteCountTableViewCellDidTap(cell)
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
extension MoviesFilterListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView === self.voteAveragePickerView {
            return 2
        } else if pickerView === self.voteCountPickerView {
            return 1
        } else if pickerView === self.releaseDatePickerView {
            return 2
        } else if pickerView === self.durationPickerView {
            return 1
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === self.voteAveragePickerView {
            if component == 0 {
                return self.filtredVoteAveragePickerViewData.minimum.count
            } else {
                return self.filtredVoteAveragePickerViewData.maximum.count
            }
        } else if pickerView === self.voteCountPickerView {
            return self.viewModel.voteCountPickerViewData.count
        } else if pickerView === self.releaseDatePickerView {
            if component == 0 {
                return self.filtredReleaseDatePickerViewData.minimum.count
            } else {
                return self.filtredReleaseDatePickerViewData.maximum.count
            }
        } else if pickerView === self.durationPickerView {
            return self.viewModel.durationDatePickerViewData.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === self.voteAveragePickerView {
            if component == 0 {
                return self.filtredVoteAveragePickerViewData.minimum[row].title
            } else {
                return self.filtredVoteAveragePickerViewData.maximum[row].title
            }
        } else if pickerView == self.voteCountPickerView {
            return self.viewModel.voteCountPickerViewData[row].title
        } else if pickerView === self.releaseDatePickerView {
            if component == 0 {
                return self.filtredReleaseDatePickerViewData.minimum[row].title
            } else {
                return self.filtredReleaseDatePickerViewData.maximum[row].title
            }
            } else if pickerView === self.durationPickerView {
            return self.viewModel.durationDatePickerViewData[row].title
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === self.voteAveragePickerView {
            if component == 0 {
                self.viewModel.voteAverageDidChanged(minimum: self.filtredVoteAveragePickerViewData.minimum[row].value, maximum: nil)
            } else {
                self.viewModel.voteAverageDidChanged(minimum: nil, maximum: self.filtredVoteAveragePickerViewData.maximum[row].value)
            }
        } else if pickerView == self.voteCountPickerView {
            self.viewModel.voteCountDidChanged(voteCount: self.viewModel.voteCountPickerViewData[row].value)
        } else if pickerView === self.releaseDatePickerView {
            if component == 0 {
                self.viewModel.releaseDateDidChanged(minimum: self.filtredReleaseDatePickerViewData.minimum[row].value, maximum: nil)
            } else {
                self.viewModel.releaseDateDidChanged(minimum: nil, maximum: self.filtredReleaseDatePickerViewData.maximum[row].value)
            }
        } else if pickerView === self.durationPickerView {
            self.viewModel.durationDidChanged(self.viewModel.durationDatePickerViewData[row].value)
        }
    }
}

extension MoviesFilterListViewController: MoviesFilterGenresListViewControllerDelegate {
    func selectedGenresDidChanged(_ genres: Set<MovieGenre>) {
        self.viewModel.genresDidChanged(genres)
    }
}
