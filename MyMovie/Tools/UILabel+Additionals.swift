//
//  UILabel+Additionals.swift
//  MyMovie
//
//  Created by Andrey Baskirtcev on 03.09.2020.
//  Copyright © 2020 Andrey Bashkirtcev. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: self.frame.size.width, height: CGFloat(Float.infinity))
        let charSize = self.font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
