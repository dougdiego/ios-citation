//
//  ViewController.swift
//  Citation
//
//  Created by Doug Diego on 1/31/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    var notificationToken: NotificationToken?
    var realm: Realm!

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = .none
        tableView.enableAutoLayout()
        return tableView
    }()

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
            }
        }

        tableView.register(CitationTableViewCell.self,
                           forCellReuseIdentifier: "CitationTableViewCell")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("viewWillAppear")
        tableView.reloadData()
    }

    func setupInterface() {
        self.title = "Citation"
        self.view.addSubview(tableView)
    }

    func setupConstraints() {
        self.tableView.constraintToEdges(superview: self.view)
    }

    deinit {
        notificationToken?.invalidate()
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = DBManager.shared.getCitations().count
        NSLog("numberOfRowsInSection \(count)")
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CitationTableViewCell(style: .default, reuseIdentifier: "CitationTableViewCell")
        let item = DBManager.shared.getCitations()[indexPath.row] as Citation
        cell.citationLabel.text = "\"\(item.citation)\" from: \(item.url)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = DBManager.shared.getCitations()[indexPath.row] as Citation
            DBManager.shared.deleteCitation(object: item)
            NSLog("calling deleteRows")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
