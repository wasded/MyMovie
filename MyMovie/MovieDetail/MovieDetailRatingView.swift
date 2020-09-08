//
//  MovieDetailRatingView.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 08.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class MovieDetailRatingView: UIView {
    // MARK: - Properties
    let cosmosView = CosmosView()
    let ratingLabel = UILabel()
    
    let color: UIColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0.1960784314, alpha: 1)
    
    var userRating: Double? = 0 {
        didSet {
            self.cosmosView.rating = self.userRating ?? 0
        }
    }
    var rating: Double = 0 {
        didSet {
            self.ratingLabel.text = String(format: "%.1f")
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
        self.addSubview(self.cosmosView)
        self.cosmosView.translatesAutoresizingMaskIntoConstraints = false
        self.cosmosView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        self.cosmosView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        self.cosmosView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.cosmosView.settings.filledBorderColor = self.color
        self.cosmosView.settings.emptyColor = .clear
        self.cosmosView.settings.filledColor = self.color
        self.cosmosView.settings.emptyBorderColor = self.color
        self.cosmosView.settings.filledBorderWidth = 1.5
        self.cosmosView.settings.emptyBorderWidth = 1.5
        self.cosmosView.settings.fillMode = .half
        self.cosmosView.settings.minTouchRating = 0.5
        self.cosmosView.settings.starSize = 26
        self.cosmosView.settings.totalStars = 10
        self.cosmosView.settings.starMargin = 3
        
        self.addSubview(self.ratingLabel)
        self.ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.ratingLabel.widthAnchor.constraint(equalToConstant: 54).isActive = true
        self.ratingLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.ratingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.ratingLabel.leadingAnchor.constraint(equalTo: self.cosmosView.trailingAnchor, constant: 8).isActive = true
        self.ratingLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        self.ratingLabel.textColor = self.color
        self.ratingLabel.layer.cornerRadius = 8
        self.ratingLabel.layer.borderWidth = 2
        self.ratingLabel.layer.borderColor = self.color.cgColor
        self.ratingLabel.textAlignment = .center
    }
}
