//
//  UILabel+Extensions.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 13.11.2023.
//

import UIKit

extension UILabel {
    var maxNumberOfLines: Int {
            let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
            let text = self.text ?? ""
            let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil).height
            let lineHeight = font.lineHeight
            return Int(ceil(textHeight / lineHeight))
    }
}
