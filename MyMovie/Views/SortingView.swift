//
//  File.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 05.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit
import Combine

protocol SortingItem {
    var text: String { get }
}

class SortingView<T: SortingItem>: UIView {
    // MARK: - Properties
    @Published var selectedSortingType: T?
    @Published var isAscOrder: Bool = false
    
    var sortingTypes = [T]() {
        didSet {
            self.reloadBubbleSegment()
        }
    }
    
    let containerView = UIView()
    let bubbleSegment = BubbleSegment()
    let isAscOrderButton = UIButton()
    let separator = UIView()
    
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
        // container
        self.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        // sortingOrderButton
        self.containerView.addSubview(self.isAscOrderButton)
        self.isAscOrderButton.translatesAutoresizingMaskIntoConstraints = false
        self.isAscOrderButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive = true
        self.isAscOrderButton.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
        self.isAscOrderButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0).isActive = true
        self.setImageForButton(for: self.isAscOrder)
        self.isAscOrderButton.addTarget(self, action: #selector(self.isAscOrderButtonDidTap(_:)), for: .touchUpInside)
        
        // separator
        self.containerView.addSubview(self.separator)
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.separator.leadingAnchor.constraint(equalTo: self.isAscOrderButton.trailingAnchor, constant: 8).isActive = true
        self.separator.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 4).isActive = true
        self.separator.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -4).isActive = true
        self.separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        self.separator.backgroundColor = .lightGray
        
        // bubbleSegment
        self.containerView.addSubview(self.bubbleSegment)
        self.bubbleSegment.translatesAutoresizingMaskIntoConstraints = false
        self.bubbleSegment.leadingAnchor.constraint(equalTo: self.separator.trailingAnchor, constant: 0).isActive = true
        self.bubbleSegment.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive = true
        self.bubbleSegment.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
        self.bubbleSegment.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0).isActive = true
        
        self.reloadBubbleSegment()
    }
    
    private func reloadBubbleSegment() {
        let bubbleElements = self.sortingTypes.map({ BubbleSegment.TitleElement(title: $0.text) })
        self.bubbleSegment.setRichTextTitles(bubbleElements)
        self.bubbleSegment.valueChange = { [weak self] index in
            guard let self = self else { return }
            self.selectedSortingType = self.sortingTypes[index]
        }
        
        self.selectedSortingType = self.sortingTypes.first
    }
    
    private func setImageForButton(for isAscOrder: Bool) {
        self.isAscOrderButton.setImage(isAscOrder ? #imageLiteral(resourceName: "ascending") : #imageLiteral(resourceName: "descending"), for: .normal)
    }
    
    private func sortingDidChanged() {
        self.selectedSortingType = self.sortingTypes[self.bubbleSegment.selectIndex]
    }
    
    // MARK: - Actions
    @objc func isAscOrderButtonDidTap(_ sender: UIButton) {
        self.isAscOrder.toggle()
    }
}
