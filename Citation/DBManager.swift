//
//  DBManager.swift
//  Citation
//
//  Created by Doug Diego on 2/1/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {

    private var database: Realm
    static let shared = DBManager()

    private init() {
        //database = try! Realm()

        // Save Realm to Shared Group:
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.org.diego.ios.Citation")!
            .appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: fileURL)
        database = try! Realm(configuration: config)
    }

    func getDatabase() -> Realm {
        return database
    }

    func getCitations() -> Results<Citation> {
        let results: Results<Citation> = database.objects(Citation.self)
        return results
    }

    func addCitation(object: Citation) {
        object.ID = getCitations().count
        try! database.write {
            database.add(object, update: true)
            print("Added new object")
        }
    }

    func deleteAllDatabase() {
        try! database.write {
            database.deleteAll()
        }
    }

    func deleteCitation(object: Citation) {
        try! database.write {
            database.delete(object)
            NSLog("deleteCitation() deleted")
        }
    }

}
