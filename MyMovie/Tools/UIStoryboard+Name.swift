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
    static var moviesListStoryboard: UIStoryboard {
        return UIStoryboard(name: "MoviesList", bundle: Bundle.main)
    }
    
    static var moviesFilterStoryboard: UIStoryboard {
        return UIStoryboard(name: "MoviesFilter", bundle: Bundle.main)
    }
    
    static var movieDetailStoryboard: UIStoryboard {
        return UIStoryboard(name: "MovieDetail", bundle: Bundle.main)
    }
}
