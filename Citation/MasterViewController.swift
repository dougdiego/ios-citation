//
//  MasterViewController.swift
//  Citation
//
//  Created by Doug Diego on 2/5/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit
import RealmSwift

protocol CitationSelectionDelegate: class {
    func citationSelected(_ newCitation: Citation)
}

class MasterViewController: UITableViewController {

    var notificationToken: NotificationToken?
    var realm: Realm!
    weak var delegate: CitationSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
        setupConstraints()

        // Set realm notification block
        notificationToken = DBManager.shared.getDatabase().observe { [unowned self] item, realm in
            NSLog("realm observed item: \(item) in realm: \(realm)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NSLog("reloadData")
                self.tableView.reloadData()
                if DBManager.shared.getCitations().count > 0 {
                    let item = DBManager.shared.getCitations()[0] as Citation
                    self.delegate?.citationSelected(item)
                    NotificationCenter.default.post(name: .dismissEmptyModal,
                                                    object: nil,
                                                    userInfo: nil)
                }
            }
        }

        tableView.register(CitationTableViewCell.self,
                           forCellReuseIdentifier: "CitationTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("MasterViewController.viewWillAppear")
        tableView.reloadData()
    }

    func setupInterface() {
        self.title = "Citation"
    }

    func setupConstraints() {
    }

    deinit {
        notificationToken?.invalidate()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = DBManager.shared.getCitations().count
        NSLog("numberOfRowsInSection \(count)")
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CitationTableViewCell(style: .default, reuseIdentifier: "CitationTableViewCell")
        let item = DBManager.shared.getCitations()[indexPath.row] as Citation
        cell.citationLabel.text = "\"\(item.citation)\" from: \(item.url)"
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = DBManager.shared.getCitations()[indexPath.row] as Citation
            DBManager.shared.deleteCitation(object: item)
            NSLog("calling deleteRows")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView.deselectRow(at: indexPath, animated: false)
        let item = DBManager.shared.getCitations()[indexPath.row] as Citation
        delegate?.citationSelected(item)

        if let detailViewController = delegate as? DetailViewController,
            let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
}
