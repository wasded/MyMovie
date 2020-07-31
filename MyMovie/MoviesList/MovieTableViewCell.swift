//
//  MovieTableViewCell.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 29.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import UIKit
import SDWebImage
import SkeletonView
import Cosmos

struct MovieTableViewData {
    var urlPoster: URL?
    var titleLabel: String
    var releaseDate: Date
    var genres: [String]
    var voteAverage: Double
    var description: String
}

class MovieTableViewCell: UITableViewCell {
    // MARK: - Properties
    let posterView = UIImageView()
    let titleLabel = UILabel()
    let additionalMovieInfoLabel = UILabel()
    let voteAverageView = CosmosView()
    let descriptionLabel = UILabel()
    let containerView = UIView()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY г."
        return dateFormatter
    }()
    
    var data: MovieTableViewData? {
        didSet {
            self.updateInterface()
        }
    }
    
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
    func configureInterface() {
        // self
        self.isSkeletonable = true
        self.skeletonCornerRadius = 8
        
        // containerView
        self.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // posterView
        self.containerView.addSubview(self.posterView)
        self.posterView.translatesAutoresizingMaskIntoConstraints = false
        self.posterView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
        self.posterView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0).isActive = true
        self.posterView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive = true
        self.posterView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        self.posterView.layer.cornerRadius = 8
        self.posterView.layer.masksToBounds = true
        self.posterView.clipsToBounds = true
        self.posterView.contentMode = .scaleToFill
        self.posterView.isSkeletonable = true
        
        // titleLabel
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.posterView.trailingAnchor, constant: 8).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive = true
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.titleLabel.textColor = .black
        self.titleLabel.textAlignment = .left
        self.titleLabel.lineBreakMode = .byTruncatingTail
        self.titleLabel.numberOfLines = 1
        
        // additionalMovieInfoLabel
        self.containerView.addSubview(self.additionalMovieInfoLabel)
        self.additionalMovieInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.additionalMovieInfoLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8).isActive = true
        self.additionalMovieInfoLabel.leadingAnchor.constraint(equalTo: self.posterView.trailingAnchor, constant: 8).isActive = true
        self.additionalMovieInfoLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive = true
        self.additionalMovieInfoLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.additionalMovieInfoLabel.textColor = .darkGray
        self.additionalMovieInfoLabel.lineBreakMode = .byTruncatingTail
        self.additionalMovieInfoLabel.textAlignment = .left
        self.additionalMovieInfoLabel.numberOfLines = 2
        
        // voteAverageView
        self.containerView.addSubview(self.voteAverageView)
        self.voteAverageView.translatesAutoresizingMaskIntoConstraints = false
        self.voteAverageView.topAnchor.constraint(equalTo: self.additionalMovieInfoLabel.bottomAnchor, constant: 16).isActive = true
        self.voteAverageView.leadingAnchor.constraint(equalTo: self.posterView.trailingAnchor, constant: 8).isActive = true
        self.voteAverageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive = true
        self.voteAverageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.voteAverageView.settings.starSize = 24
        self.voteAverageView.settings.fillMode = .half
        self.voteAverageView.settings.updateOnTouch = false
        self.voteAverageView.settings.disablePanGestures = true
        self.voteAverageView.contentMode = .center
        
        // descriptionLabel
        self.containerView.addSubview(self.descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.topAnchor.constraint(equalTo: self.voteAverageView.bottomAnchor, constant: 16).isActive = true
        self.descriptionLabel.leadingAnchor.constraint(equalTo: self.posterView.trailingAnchor, constant: 8).isActive = true
        self.descriptionLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor, constant: 0).isActive = true
        self.descriptionLabel.lineBreakMode = .byTruncatingTail
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.descriptionLabel.textColor = .darkGray
        self.descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private func updateInterface() {
        guard let data = self.data else { return }
        
        UIView.performWithoutAnimation {
            self.posterView.image = nil
        }
        
        self.titleLabel.text = data.titleLabel
        
        self.additionalMovieInfoLabel.text = String(format: "%@ %@", self.dateFormatter.string(from: data.releaseDate), data.genres.joined(separator: "/"))
        
        self.descriptionLabel.text = data.description
        
        self.voteAverageView.settings.totalStars = 5
        self.voteAverageView.rating = data.voteAverage / 2
        
        self.posterView.showAnimatedGradientSkeleton()
        self.posterView.sd_setImage(with: data.urlPoster, placeholderImage: nil) { [weak self] (_, error, _, _) in
            guard let self = self else { return }
            self.posterView.hideSkeleton()
            if let _ = error {
                UIView.performWithoutAnimation {
                    self.posterView.image = nil
                }
            }
        }
    }
}
