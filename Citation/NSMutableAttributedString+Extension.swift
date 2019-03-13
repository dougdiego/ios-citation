//
//  NSMutableAttributedString+Extension.swift
//  Citation
//
//  Created by Doug Diego on 3/11/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    func termsAttributes(terms: [NSString],
                         commonAttributes: [NSAttributedString.Key: Any],
                         termsAttributes: [NSAttributedString.Key: Any] ) {
        let string = self.string as NSString
        let range = NSRange.init(location: 0, length: self.length)
        self.addAttributes(commonAttributes, range: range)
        for term in terms {
            let underlineRange = string.range(of: term as String)
            self.addAttributes(termsAttributes, range: underlineRange)
        }
    }

    func linkAttributes(terms: [NSString], linkColor: UIColor) {
        let commonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: UIColor.black
        ]
        let termsAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: linkColor as UIColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.termsAttributes(terms: terms,
                             commonAttributes: commonAttributes,
                             termsAttributes: termsAttributes)
    }

    func addAttributes(attributes: [NSAttributedString.Key: Any]) {
        let range = NSRange.init(location: 0, length: self.length)
        self.addAttributes(attributes, range: range)
    }
}
