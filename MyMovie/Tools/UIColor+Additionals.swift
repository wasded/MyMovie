//
//  UIColor+Additionals.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 01.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func isLight(threshold: Float = 0.5) -> Bool {
        let originalCGColor = self.cgColor

        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return false
        }
        guard components.count >= 3 else {
            return false
        }

        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}

extension UIColor {
    open class var posterOverlayColor: UIColor {
        return UIColor(named: "posterOverlayColor")!
    }
    
    open class var mainTextColor: UIColor {
        return UIColor(named: "mainTextColor")!
    }
}
