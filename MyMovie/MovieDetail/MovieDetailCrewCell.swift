//
//  MovieDetailCrewCell.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 04.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

struct MovieDetailCrewCellData {
    let crew: [MoviePersonInfo]
}

struct MoviePersonInfo {
    let name: String
    let job: String
    let imageURL: URL?
}

class MovieDetailCrewView: UIView {
    // MARK: - Properties
    let profileImageView = UIImageView()
    let fullnameLabel = UILabel()
    let jobLabel = UILabel()
    
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
        self.addSubview(self.profileImageView)
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 96).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 96).isActive = true
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = 48
        
        self.addSubview(self.fullnameLabel)
        self.fullnameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.fullnameLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 4).isActive = true
        self.fullnameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.fullnameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.fullnameLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        self.fullnameLabel.numberOfLines = 2
        self.fullnameLabel.textAlignment = .center
        
        self.addSubview(self.jobLabel)
        self.jobLabel.translatesAutoresizingMaskIntoConstraints = false
        self.jobLabel.topAnchor.constraint(equalTo: self.fullnameLabel.bottomAnchor, constant: 0).isActive = true
        self.jobLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.jobLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.jobLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.jobLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.jobLabel.numberOfLines = 1
        self.jobLabel.textAlignment = .center
    }
}

class MovieDetailCrewCell: UITableViewCell {
    // MARK: - Properties
    var data: MovieDetailCrewCellData? {
        didSet {
            self.updateInterface()
        }
    }
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let stackView = UIStackView()
    let titleLabel = UILabel()
    
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
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        self.titleLabel.text = "Актеры и создатели"
        
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bouncesZoom = false
        
        self.scrollView.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        
        let widthAnchor = self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        widthAnchor.priority = UILayoutPriority(250)
        widthAnchor.isActive = true
        
        let heightAnchor = self.containerView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        heightAnchor.priority = UILayoutPriority(250)
        heightAnchor.isActive = true
        
        self.containerView.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -16).isActive = true
        self.stackView.axis = .horizontal
        self.stackView.spacing = 16
    }
    
    private func updateInterface() {
        self.stackView.arrangedSubviews.forEach({ self.stackView.removeArrangedSubview($0); $0.removeFromSuperview() })
        
        if let data = self.data {
            let actorsView = self.generateCrewViews(data.crew)
            actorsView.forEach({ self.stackView.addArrangedSubview($0) })
        }
    }
    
    private func generateCrewViews(_ crew: [MoviePersonInfo]) -> [MovieDetailCrewView] {
        return crew.map { (crew) -> MovieDetailCrewView in
            let view = MovieDetailCrewView()
            view.fullnameLabel.text = crew.name
            view.jobLabel.text = crew.job
            
            if let imageURL = crew.imageURL {
                view.backgroundColor = nil
                view.profileImageView.sd_setImage(with: imageURL, completed: nil)
            } else {
                view.profileImageView.image = #imageLiteral(resourceName: "noImage")
                view.profileImageView.backgroundColor = .mainTextColor
            }
            
            return view
        }
    }
}
