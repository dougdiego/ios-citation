//
//  DetailViewModel.swift
//  Citation
//
//  Created by Doug Diego on 3/8/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import Foundation

class DetailViewModel: NSObject {
    var citation: Citation?

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRows(inSection section: Int) -> Int {
        if hasCitation() {
            return Rows.numOfRows(sectionIndex: section)
        }
        return 0
    }

    func valueForCell(atIndexPath indexPath: IndexPath) -> String? {
        return Rows.valueForCell(atIndexPath: indexPath, viewModel: self)
    }

    func hasCitation() -> Bool {
        if citation == nil {
            return false
        }
        return true
    }
}

extension DetailViewModel {
    public enum Rows: Int {
        case citation
        //case divider1
        case url
        case divider1
        case comment
        static let count: Int = {
            var max: Int = 0
            while Rows(rawValue: max) != nil { max += 1 }
            return max
        }()

        static func numOfRows(sectionIndex index: Int) -> Int {
            return Rows.count
        }

        static func valueForCell(atIndexPath indexPath: IndexPath, viewModel: DetailViewModel ) -> String? {
            guard let row = Rows(rawValue: indexPath.row) else { return nil }
            switch row {
            case .citation:
                return viewModel.citation?.citation
//            case .divider1:
//                return nil
            case .url:
                return viewModel.citation?.url
            case .divider1:
                return nil
            case .comment:
                return viewModel.citation?.comment
            }
        }
    }
}
