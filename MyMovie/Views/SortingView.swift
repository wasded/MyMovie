//
//  SortingView.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 29.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Delegate
protocol SortingViewDelegate: class {
    func valueChanged(sortingType: SortingView.SortingType, isAscOrder: Bool)
}

class SortingView: UIView {
    enum SortingType: CaseIterable {
        case pupularity
        case releaseDate
        case revenue
        case primaryReleaseDate
        case originalTitle
        case voteAverage
        case voteCount
        
        func getDescription() -> String {
            switch self {
            case .pupularity:
                return "Популярность"
            case .releaseDate:
                return "Дата релиза"
            case .revenue:
                return "Сборы"
            case .primaryReleaseDate:
                return "Дата основного выпуска"
            case .originalTitle:
                return "Название"
            case .voteAverage:
                return "Оценки"
            case .voteCount:
                return "Колличество оценок"
            }
        }
    }
    
    // MARK: - Properties
    let sortingTypes = SortingType.allCases
    
    let bubbleSegment = BubbleSegment()
    let isAscOrderButton = UIButton()
    let separator = UIView()
    
    weak var delegate: SortingViewDelegate?
    
    private(set) var isAscOrder: Bool = false {
        didSet {
            if self.isAscOrder != oldValue {
                self.setImageForButton(for: self.isAscOrder)
                self.sortingDidChanged()
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureInterface()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureInterface()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureInterface()
    }
    
    // MARK: - Methods
    private func configureInterface() {
        // sortingOrderButton
        self.addSubview(self.isAscOrderButton)
        self.isAscOrderButton.translatesAutoresizingMaskIntoConstraints = false
        self.isAscOrderButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        self.isAscOrderButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.isAscOrderButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.setImageForButton(for: self.isAscOrder)
        self.isAscOrderButton.addTarget(self, action: #selector(self.isAscOrderButtonDidTap(_:)), for: .touchUpInside)
        
        // separator
        self.addSubview(self.separator)
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.separator.leadingAnchor.constraint(equalTo: self.isAscOrderButton.trailingAnchor, constant: 8).isActive = true
        self.separator.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        self.separator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        self.separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        self.separator.backgroundColor = .lightGray
        
        // bubbleSegment
        self.addSubview(self.bubbleSegment)
        self.bubbleSegment.translatesAutoresizingMaskIntoConstraints = false
        self.bubbleSegment.leadingAnchor.constraint(equalTo: self.separator.trailingAnchor, constant: 0).isActive = true
        self.bubbleSegment.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.bubbleSegment.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.bubbleSegment.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        let bubbleElements = self.sortingTypes.map({ BubbleSegment.TitleElement(title: $0.getDescription()) })
        self.bubbleSegment.setRichTextTitles(bubbleElements)
        self.bubbleSegment.valueChange = { [weak self] index in
            self?.sortingDidChanged()
        }
    }
    
    private func setImageForButton(for isAscOrder: Bool) {
        self.isAscOrderButton.setImage(isAscOrder ? #imageLiteral(resourceName: "profileTabBar") : #imageLiteral(resourceName: "profileTabBar"), for: .normal)
    }
    
    @objc func isAscOrderButtonDidTap(_ sender: UIButton) {
        self.isAscOrder.toggle()
    }
    
    private func sortingDidChanged() {
        let selectedSortingType = self.sortingTypes[self.bubbleSegment.selectIndex]
        self.delegate?.valueChanged(sortingType: selectedSortingType, isAscOrder: self.isAscOrder)
    }
}
