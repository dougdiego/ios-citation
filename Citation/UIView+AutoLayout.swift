//
//  UIView+AutoLayout.swift
//  Citation
//
//  Created by Doug Diego on 2/1/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit

extension UIView {
    public func enableAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    public func constraintToEdges(superview: UIView) {
        constraintToEdges(superview: superview, constant: 0)
    }

    public func constraintToEdges(superview: UIView, constant: CGFloat) {
        guard let mySuperView = self.superview else { fatalError("No superview") }
        guard mySuperView.isEqual(superview) else { fatalError("Wrong superview") }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).activate()
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).activate()
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).activate()
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant).activate()
    }
}
