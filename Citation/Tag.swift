//
//  Tag.swift
//  Citation
//
//  Created by Doug Diego on 2/14/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit
import RealmSwift

class Tag: Object {
    @objc dynamic var ID = -1
    @objc dynamic var tag = ""
    @objc dynamic var created = Date()
    @objc dynamic var updated = Date()

    override static func primaryKey() -> String? {
        return "ID"
    }
}
