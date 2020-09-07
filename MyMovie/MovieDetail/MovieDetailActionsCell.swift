//
//  MovieDetailActionsCell.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 03.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MovieDetailActionView
class MovieDetailActionView: UIView {
    // MARK: - Properties
    var image: UIImage? {
        didSet {
            self.updateInterface()
        }
    }
    
    var text: String? {
        didSet {
            self.updateInterface()
        }
    }
    
    var color: UIColor = .black {
        didSet {
            self.updateInterface()
        }
    }
    
    let imageView = UIImageView()
    let textLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureInterface()
        self.updateInterface()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureInterface()
        self.updateInterface()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureInterface()
        self.updateInterface()
    }
    
    // MARK: - Methods
    private func configureInterface() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.widthAnchor.constraint(equalToConstant: 17).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.imageView.contentMode = .scaleAspectFit
        
        self.addSubview(self.textLabel)
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.textLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 6).isActive = true
        self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.textLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private func updateInterface() {
        self.layer.borderColor = self.color.cgColor
        self.textLabel.textColor = self.color
        self.textLabel.text = text
        self.imageView.image = self.image
    }
}

// MARK: - Data
struct MovieDetailActionsCellData: Equatable {
    var isWatchLater: Bool
    var isFavorite: Bool
}

// MARK: - Cell
class MovieDetailActionsCell: UITableViewCell {
    // MARK: - Properties
    var data: MovieDetailActionsCellData? {
        didSet {
            self.updateInterface()
        }
    }
    
    let watchLaterView = MovieDetailActionView()
    let favoriteView = MovieDetailActionView()
    
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
        self.addSubview(self.watchLaterView)
        self.watchLaterView.translatesAutoresizingMaskIntoConstraints = false
        self.watchLaterView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        self.watchLaterView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.watchLaterView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        self.watchLaterView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        self.watchLaterView.color = #colorLiteral(red: 0.2862745098, green: 0.5764705882, blue: 0, alpha: 1)
        
        self.addSubview(self.favoriteView)
        self.favoriteView.translatesAutoresizingMaskIntoConstraints = false
        self.favoriteView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        self.favoriteView.leadingAnchor.constraint(equalTo: self.watchLaterView.trailingAnchor, constant: 28).isActive = true
        self.favoriteView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        self.favoriteView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        self.favoriteView.color = #colorLiteral(red: 1, green: 0.262745098, blue: 0.262745098, alpha: 1)
    }
    
    private func updateInterface() {
        guard let data = self.data else { return }
        self.watchLaterView.text = "Смотреть позже"
        self.watchLaterView.image = #imageLiteral(resourceName: "watchLater")
        
        self.favoriteView.text = "Любимое"
        self.favoriteView.image = #imageLiteral(resourceName: "favorite")
    }
}
