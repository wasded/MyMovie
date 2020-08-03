//
//  MoviesFilterListKeyboardToolBar.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 03.08.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

class MoviesFilterListKeyboardToolBar: UIToolbar {
    // MARK: - Proprties
    private(set) var closeButton = UIBarButtonItem()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureInterface()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureInterface()
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureInterface()
    }
    
    // MARK: - Methods
    func configureInterface() {
        self.autoresizingMask = .flexibleHeight
        
        let closeButton = UIBarButtonItem()
        closeButton.title = "Закрыть"
        self.closeButton = closeButton
        
        self.items = [
            self.closeButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
        ]
        
        self.sizeToFit()
    }
}
