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
    @objc dynamic var citation = ""
    @objc dynamic var comment = ""
    @objc dynamic var created = Date()
    @objc dynamic var updated = Date()

    override static func primaryKey() -> String? {
        return "ID"
    }
}
