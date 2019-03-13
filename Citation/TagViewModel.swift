//
//  TagViewModel.swift
//  Citation
//
//  Created by Doug Diego on 2/14/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit
import os.log

public enum TagView {
    case all
    case user
}

@objc protocol TagDelegate: class {
    @objc optional func didStaringLoadingData(_ viewModel: TagViewModel)
    func didLoadData(_ viewModel: TagViewModel)
    @objc optional func errorLoadingData(_ viewModel: TagViewModel)
}

class TagViewModel: NSObject {

    private let log = OSLog(category: "TagViewModel")
    fileprivate weak var delegate: TagDelegate?
    var tagView: TagView = .all
    var selectedTags: [Tag] = []

    func isAllTags() -> Bool {
        return tagView == .all ? true : false
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numOfRows(inSection section: Int) -> Int {
        let count = DBManager.shared.getTags().count
        log.debug("numberOfRowsInSection %d", count)
        return count
    }

    func tagForCell(atIndexPath indexPath: IndexPath) -> String {
        let tags = DBManager.shared.getTags()
        return tags[indexPath.row].tag
    }

    func isSelectedTagForCell(atIndexPath indexPath: IndexPath) -> Bool {
        let item = DBManager.shared.getTags()[indexPath.row] as Tag
        if selectedTags.contains(item) {
            return true
        } else {
            return false
        }
    }
}
