//
//  MovieDetailDescriptionCell.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 03.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

struct MovieDetailDescriptionCellData: Equatable {
    var descritpion: String?
}

class MovieDetailDescriptionCell: UITableViewCell {
    // MARK: - Properties
    var data: MovieDetailDescriptionCellData? {
        didSet {
            self.updateInterface()
        }
    }
    
    var isExpand: Bool = false {
        didSet {
            self.updateInterface()
        }
    }
    
    var expandButtonBottomConstraint = NSLayoutConstraint()

    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let expandButton = UIButton()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        self.titleLabel.text = "Описание"
        
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12).isActive = true
        self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -48).isActive = true
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.descriptionLabel.numberOfLines = 6
        self.descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        self.addSubview(self.expandButton)
        self.expandButton.translatesAutoresizingMaskIntoConstraints = false
        self.expandButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 8).isActive = true
        self.expandButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.expandButtonBottomConstraint = self.expandButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        self.expandButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.expandButton.tintColor = .mainTextColor
        self.expandButton.setTitle("Развернуть", for: .normal)
        self.expandButton.addTarget(self, action: #selector(self.expandButtonDidTap(_:)), for: .touchUpInside)
        
        self.layoutIfNeeded() // нужно для подсчета колличнства линий в descriptionLabel
    }
    
    private func updateInterface() {
        guard let data = self.data else { return }
        
        self.descriptionLabel.numberOfLines = self.isExpand ? 0 : 6
        self.descriptionLabel.text = data.descritpion
        
        if self.descriptionLabel.calculateMaxLines() <= 6 || self.isExpand {
            self.expandButtonBottomConstraint.isActive = false
            self.expandButton.isHidden = true
            self.expandButton.isEnabled = false
        } else {
            self.expandButtonBottomConstraint.isActive = true
            self.expandButton.isHidden = false
            self.expandButton.isEnabled = true
        }
    }
    
    // MARK: - Actions
    @objc func expandButtonDidTap(_ sender: UIButton) {
        
        self.isExpand = true
    }
}
