//
//  DBManager.swift
//  Citation
//
//  Created by Doug Diego on 2/1/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import Foundation
import RealmSwift
import os.log

class DBManager {
    private let log = OSLog(category: "TagViewController")
    private var database: Realm
    static let shared = DBManager()

    private init() {
        // Save Realm to Shared Group:
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.org.diego.ios.Citation")!
            .appendingPathComponent("default.realm")
        log.info("realm: %s", String(describing: fileURL))
        let config = Realm.Configuration(fileURL: fileURL)
        database = try! Realm(configuration: config)
    }

    func getDatabase() -> Realm {
        return database
    }

    func deleteAllDatabase() {
        try! database.write {
            database.deleteAll()
        }
    }

    func getCitations() -> Results<Citation> {
        let results: Results<Citation> = database.objects(Citation.self)
        return results
    }

    func addCitation(object: Citation) {
        object.ID = getCitations().count
        try! database.write {
            database.add(object, update: true)
            log.debug("Added new citation")
        }
    }

    func deleteCitation(object: Citation) {
        try! database.write {
            database.delete(object)
            log.debug("deleteCitation() deleted")
        }
    }

    func getTags() -> Results<Tag> {
       return database.objects(Tag.self)
    }

    func addTag(object: Tag) {
        object.ID = getTags().count + 1
        try! database.write {
            database.add(object, update: true)
            log.debug("Added new tag")
        }
    }

    func deleteTag(object: Tag) {
        try! database.write {
            database.delete(object)
            log.debug("deleteTag() deleted")
        }
    }

}
