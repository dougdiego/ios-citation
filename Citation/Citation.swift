//
//  Citation.swift
//  Citation
//
//  Created by Doug Diego on 2/1/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

// https://realm.io/docs/swift/latest/
// https://realm.io/docs/tutorials/realmtasks/

import UIKit
import RealmSwift

class Citation: Object {
    @objc dynamic var ID = -1
    @objc dynamic var url = ""
    @objc dynamic var title = ""
    @objc dynamic var citation = ""
    @objc dynamic var citationHtml = ""
    @objc dynamic var comment = ""
    @objc dynamic var screenshotUrl = ""
    @objc dynamic var pdfUrl = ""
    @objc dynamic var bodyText = ""
    @objc dynamic var created = Date()
    @objc dynamic var updated = Date()
    var tags = List<Tag>()

    override static func primaryKey() -> String? {
        return "ID"
    }
}
