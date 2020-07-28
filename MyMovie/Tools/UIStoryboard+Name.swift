//
//  UIStoryboard+Name.swift
//  MyMovie
//
//  Created by Andrey Bashkirtcev on 28.07.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    static var movieListStoryboard: UIStoryboard {
        return UIStoryboard(name: "MovieList", bundle: Bundle.main)
    }
}
