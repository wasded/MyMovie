//
//  MovieCollectionViewCell.swift
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

class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    let posterView = UIImageView()
    let titleLabel = UILabel()
    
    var data: MovieCollectionViewData? {
        didSet {
            self.updateInterface()
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
    func configureInterface() {
        // self
        self.isSkeletonable = true
        self.skeletonCornerRadius = 8
        
        // posterView
        self.addSubview(self.posterView)
        self.posterView.translatesAutoresizingMaskIntoConstraints = false
        self.posterView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        self.posterView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.posterView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.posterView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        self.posterView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        self.posterView.contentMode = .scaleAspectFill
        self.posterView.isSkeletonable = true
        self.posterView.layer.cornerRadius = 8
        self.posterView.layer.masksToBounds = true
        
        // titleLabel
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.posterView.bottomAnchor, constant: 8).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
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
