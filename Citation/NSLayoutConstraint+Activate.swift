//
//  NSLayoutConstraint+Activate.swift
//  Citation
//
//  Created by Doug Diego on 2/1/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    @discardableResult public func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }
}
