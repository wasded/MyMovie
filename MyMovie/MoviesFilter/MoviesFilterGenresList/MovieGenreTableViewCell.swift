//
//  MovieGenreTableViewCell.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 04.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import UIKit

// MARK: - Data
struct MovieGenreTableViewCellData: Equatable {
    var type: MovieGenre
    var isSelected: Bool
}

class MovieGenreTableViewCell: UITableViewCell {
    // MARK: - Properties
    var data: MovieGenreTableViewCellData? {
        didSet {
            self.updateInterface()
        }
    }
    
    let titleLabel = UILabel()
    let isSelectedImageView = UIImageView()

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
        self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        self.addSubview(self.isSelectedImageView)
        self.isSelectedImageView.translatesAutoresizingMaskIntoConstraints = false
        self.isSelectedImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        self.isSelectedImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.isSelectedImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.isSelectedImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        self.isSelectedImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        self.contentMode = .scaleAspectFit
    }
    
    private func updateInterface() {
        guard let data = self.data else { return }
        self.titleLabel.text = data.type.name
        self.accessoryType = data.isSelected ? .checkmark : .none
    }
}
