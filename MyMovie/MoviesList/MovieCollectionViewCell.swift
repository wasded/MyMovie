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

struct MovieCollectionViewData {
    var urlPoster: URL?
    var titleLabel: String?
}

class MovieTableViewCell: UITableViewCell {
    // MARK: - Properties
    let posterView = UIImageView()
    let titleLabel = UILabel()
    
    var data: MovieCollectionViewData? {
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
        
        // posterView
        self.addSubview(self.posterView)
        self.posterView.translatesAutoresizingMaskIntoConstraints = false
        self.posterView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        self.posterView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.posterView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 16).isActive = true
        self.posterView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        self.posterView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.posterView.layer.cornerRadius = 8
        self.posterView.layer.masksToBounds = true
        self.posterView.contentMode = .scaleAspectFill
        self.posterView.isSkeletonable = true
        
        // titleLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.posterView.trailingAnchor, constant: 24).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.titleLabel.textAlignment = .center
        self.titleLabel.lineBreakMode = .byTruncatingTail
        self.titleLabel.numberOfLines = 1
    }
    
    private func updateInterface() {
        guard let data = data else { return }
        self.titleLabel.text = data.titleLabel
        self.posterView.showAnimatedGradientSkeleton()

        UIView.animate(withDuration: 0) {
            self.posterView.sd_setImage(with: data.urlPoster, placeholderImage: nil) { (_, error, _, _) in
                self.posterView.hideSkeleton()
                if let _ = error {
                    self.posterView.image = nil
                }
            }
        }
    }
}
