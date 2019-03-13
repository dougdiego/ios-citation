//
//  CitationListTableViewCell.swift
//  Citation
//
//  Created by Doug Diego on 3/7/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit
import os.log

extension CitationListTableViewCell {
    fileprivate struct Padding {
        static let left: CGFloat = 16
        static let right: CGFloat = -16
        static let top: CGFloat = 8
        static let bottom: CGFloat = -8.0
    }
}

class CitationListTableViewCell: UITableViewCell {
    private let log = OSLog(category: "CitationListTableViewCell")

    private lazy var citationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.enableAutoLayout()
        return label
    }()

    private lazy var urlLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = UIColor(named: "Theme")
        label.enableAutoLayout()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.contentView.addSubview(citationLabel)
        self.contentView.addSubview(urlLabel)

        citationLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Padding.top).activate()
        citationLabel.bottomAnchor.constraint(equalTo: self.urlLabel.topAnchor, constant: Padding.bottom).activate()
        citationLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Padding.left).activate()
        citationLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: Padding.right).activate()

        urlLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: Padding.bottom).activate()
        urlLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Padding.left).activate()
        urlLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: Padding.right).activate()
    }

    func setCitation(_ citation: Citation) {
        citationLabel.text = citation.citation
        let attributedText = NSMutableAttributedString(string: citation.url)
        attributedText.linkAttributes(terms: [citation.url as NSString], linkColor: UIColor(named: "Theme") ?? .blue )
        urlLabel.attributedText = attributedText
    }
}
