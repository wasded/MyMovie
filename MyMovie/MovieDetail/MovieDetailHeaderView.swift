//
//  MovieDetailTableHeader.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 01.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

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
    let overlayImageView = UIView()
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
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]//[.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        
        self.addSubview(self.posterImageView)
        self.posterImageView.translatesAutoresizingMaskIntoConstraints = false
        self.posterImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.posterImageView.contentMode = .top
        self.posterImageView.clipsToBounds = true
        
        self.addSubview(self.posterImageView)
        self.posterImageView.translatesAutoresizingMaskIntoConstraints = false
        self.posterImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.posterImageView.contentMode = .top
        self.posterImageView.clipsToBounds = true
        
        self.addSubview(self.infoLabel)
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        self.infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.infoLabel.numberOfLines = 2
        
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.infoLabel.topAnchor, constant: -16).isActive = true
        self.titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .regular)

        self.posterImageView.addSubview(self.overlayImageView)
        self.overlayImageView.translatesAutoresizingMaskIntoConstraints = false
        self.overlayImageView.topAnchor.constraint(equalTo: self.posterImageView.topAnchor).isActive = true
        self.overlayImageView.bottomAnchor.constraint(equalTo: self.posterImageView.bottomAnchor).isActive = true
        self.overlayImageView.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor).isActive = true
        self.overlayImageView.trailingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor).isActive = true
        self.overlayImageView.backgroundColor = .posterOverlayColor
    }
    
    private func updateInterface() {
        guard let data = self.data else { return }
        
        self.titleLabel.text = data.title
        self.infoLabel.text = data.info
        
        if let posterURL = data.posterURL {
            SDWebImageManager.shared.loadImage(with: posterURL, progress: nil) { [weak self] (image, _, _, _, _, _) in
                guard let self = self else { return }
                if let image = image {
                    self.posterImageView.image = image.aspectFitImage(inRect: CGRect(origin: .zero, size: CGSize(width: self.posterImageView.frame.width, height: .greatestFiniteMagnitude)))
                }
            }
        }
    }
    
    // MARK: - Actions
}
