//
//  TagViewController.swift
//  Citation
//
//  Created by Doug Diego on 2/14/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit
import os.log

protocol TagViewControllerDelegate: class {
    func selectedTags(tags: [Tag]?)
}

class TagViewController: UIViewController {
    private let log = OSLog(category: "TagViewController")
    var viewModel: TagViewModel
    weak var delegate: TagViewControllerDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.enableAutoLayout()
        return tableView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: TagViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tags"
        setupInterface()
        setupConstraints()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    func setupInterface() {
        // Add TableView
        self.view.addSubview(tableView)

        if self.viewModel.isAllTags() {
            self.navigationItem.leftBarButtonItem =
                UIBarButtonItem(image: UIImage(named: "navbar-close"),
                                style: .plain,
                                target: self,
                                action: #selector(closeButtonTouched(_:)))
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addButtonTouched(_:)))
    }

    func setupConstraints() {
        self.tableView.constraintToEdges(superview: self.view)
    }

    func addNewTag() {
        let alertController = UIAlertController(title: NSLocalizedString("tag_enter_tag", comment: ""),
                                                message: "",
                                                preferredStyle: .alert)

        alertController.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            let tag = alertController.textFields![0]
            // do something interesting with "answer" here
            self.log.debug("%s", String(describing: tag))
            let newTag = Tag()
            newTag.tag = tag.text ?? ""
            newTag.created = Date()
            newTag.updated = Date()
            DBManager.shared.addTag(object: newTag)
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("common_cancel", comment: ""),
                                         style: .cancel) { (_) -> Void in
        }
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)

        self.present(alertController, animated: true, completion: nil)
    }

    @objc func closeButtonTouched(_ button: UIBarButtonItem) {
        log.debug("closeButtonTouched")
        self.dismiss(animated: true, completion: nil)
    }

    @objc func addButtonTouched(_ button: UIBarButtonItem) {
        log.debug("addButtonTouched")
        addNewTag()
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - UITableViewCell
extension TagViewController {

    func tagCell(_ indexPath: IndexPath) -> UITableViewCell {

        let identifier: String = "tagCell"
        var cell: UITableViewCell? = (tableView.dequeueReusableCell(withIdentifier: identifier))
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
            //cell?.separatorInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        }
        let tag = self.viewModel.tagForCell(atIndexPath: indexPath)
        let isSelected = self.viewModel.isSelectedTagForCell(atIndexPath: indexPath)
        cell?.textLabel?.text = tag
        if isSelected {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }

}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - UITableViewDataSource
extension TagViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tagCell(indexPath)
    }

   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = DBManager.shared.getTags()[indexPath.row] as Tag
            DBManager.shared.deleteTag(object: item)
            log.debug("calling deleteRows")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = DBManager.shared.getTags()[indexPath.row] as Tag
        if !self.viewModel.isAllTags() {
            if let index = viewModel.selectedTags.index(of: item) {
                // remove
                self.viewModel.selectedTags.remove(at: index)
            } else {
                // add
                viewModel.selectedTags.append(item)
            }
            self.delegate?.selectedTags( tags: self.viewModel.selectedTags)
        }
        self.tableView.reloadData()
    }
}

extension TagViewController {
    static func presentAdminViewController(caller: UIViewController) {
        let vm = TagViewModel()
        let vc = TagViewController(viewModel: vm)
        let nav = UINavigationController(rootViewController: vc)
        caller.present(nav, animated: true, completion: nil)
    }
}
