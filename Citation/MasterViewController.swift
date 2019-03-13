//
//  MasterViewController.swift
//  Citation
//
//  Created by Doug Diego on 2/5/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit
import RealmSwift
import os.log
import PopupDialog

protocol CitationSelectionDelegate: class {
    func citationSelected(_ newCitation: Citation)
}

class MasterViewController: UITableViewController {
    private let log = OSLog(category: "MasterViewController")
    var notificationToken: NotificationToken?
    var realm: Realm!
    weak var delegate: CitationSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
        setupConstraints()

        // Set realm notification block
        notificationToken = DBManager.shared.getDatabase().observe { [unowned self] item, realm in
            self.log.debug("realm observed item: %s in realm: %s", String(describing: item), String(describing: realm))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.log.debug("reloadData")
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

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()

        tableView.register(CitationTableViewCell.self,
                           forCellReuseIdentifier: "CitationTableViewCell")
        tableView.register(CitationListTableViewCell.self,
                           forCellReuseIdentifier: "CitationListTableViewCell")

        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "gear"),
                            style: .plain,
                            target: self,
                            action: #selector(showSettingsPopup(_:)))

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log.debug("MasterViewController.viewWillAppear")
        tableView.reloadData()
    }

    func setupInterface() {
        self.title = "Citation"

        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Tags",
                            style: .plain,
                            target: self,
                            action: #selector(tagButtonTouched(_:)))
    }

    func setupConstraints() {
    }

    deinit {
        notificationToken?.invalidate()
    }

    @objc func showSettingsPopup(_ button: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Settings") as! SettingsPopupViewController

        configurePopup(controller)

        let popup = PopupDialog.init(viewController: controller, buttonAlignment: .vertical, transitionStyle: .bounceUp, preferredWidth: 100, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false, completion: nil)

        let doneButton = DefaultButton.init(title: "Close", height: 50, dismissOnTap: true, action: nil)

        doneButton.backgroundColor = UIColor(named: "Theme")?.withAlphaComponent(0.7)
        doneButton.titleColor = UIColor.init(white: 1, alpha: 1)
        doneButton.titleFont = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)

        doneButton.tag = 1
        popup.addButtons([doneButton])

        self.present(popup, animated: true, completion: nil)
    }

    func configurePopup(_ controller: UIViewController) {
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.widthAnchor.constraint(equalToConstant: self.view.bounds.size.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right - 30).isActive = true
        controller.view.heightAnchor.constraint(equalToConstant: self.view.bounds.size.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom - 100).isActive = true
    }

    @objc func tagButtonTouched(_ button: UIBarButtonItem) {
        log.debug("tagButtonTouched")
        TagViewController.presentAdminViewController(caller: self)
    }

    func citationListCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitationListTableViewCell",
                                                 for: indexPath) as! CitationListTableViewCell
        let item = DBManager.shared.getCitations()[indexPath.row] as Citation
        cell.setCitation(item)
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = DBManager.shared.getCitations().count
        log.debug("numberOfRowsInSection %d", count)
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return citationListCell(indexPath)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = DBManager.shared.getCitations()[indexPath.row] as Citation
            DBManager.shared.deleteCitation(object: item)
            log.debug("calling deleteRows")
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
