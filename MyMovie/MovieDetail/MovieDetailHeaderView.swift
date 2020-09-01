//
//  MovieDetailTableHeader.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 01.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

struct MovieDetailHeaderData {
    var posterURL: URL?
    var title: String?
    var info: String?
}

class MovieDetailHeaderView: UIView {
    // MARK: - Properties
    var data: MovieDetailHeaderData? {
        didSet {
            self.updateInterface()
        }
    }
    
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    
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
        self.backgroundColor = .red
        
        self.addSubview(self.posterImageView)
        self.posterImageView.translatesAutoresizingMaskIntoConstraints = false
        self.posterImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.posterImageView.contentMode = .scaleAspectFill
        self.posterImageView.clipsToBounds = true
        
        self.addSubview(self.infoLabel)
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        self.infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.infoLabel.textColor = .white
        self.infoLabel.numberOfLines = 2
        
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.infoLabel.topAnchor, constant: -16).isActive = true
        self.titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        self.titleLabel.textColor = .white
    }
    
    private func updateInterface() {
        guard let data = self.data else { return }
        self.titleLabel.text = data.title
        self.infoLabel.text = data.info
        if let posterURL = data.posterURL {
            self.posterImageView.sd_setImage(with: posterURL, completed: nil)
        }
    }
    
    // MARK: - Actions
}
