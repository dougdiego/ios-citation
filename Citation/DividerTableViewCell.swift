//
//  DividerTableViewCell.swift
//  Citation
//
//  Created by Doug Diego on 3/11/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit

class DividerTableViewCell: UITableViewCell {
    let margin: CGFloat = 40

    lazy var dividerView: UIView = {
        let dividerView = UIView(frame: .zero)
        dividerView.backgroundColor = .gray
        dividerView.enableAutoLayout()
        return dividerView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        contentView.addSubview(dividerView)
        dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).activate()
        dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).activate()
        dividerView.heightAnchor.constraint(equalToConstant: 1).activate()
        dividerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).activate()
    }
}
