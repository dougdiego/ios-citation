//
//  CitationTableViewCell.swift
//  Citation
//
//  Created by Doug Diego on 2/1/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit

class CitationTableViewCell: UITableViewCell {

    lazy var citationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.enableAutoLayout()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(citationLabel)

        citationLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor).activate()
        citationLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor).activate()
        citationLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).activate()
        citationLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).activate()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
