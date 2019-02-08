//
//  DetailViewController.swift
//  Citation
//
//  Created by Doug Diego on 2/5/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var citation: Citation? {
        didSet {
            self.tableView.reloadData()
            toggleCitationButton()
        }
    }

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

        tableView.register(CitationTableViewCell.self,
                           forCellReuseIdentifier: "CitationTableViewCell")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("DetailViewController.viewWillAppear() citation: \(String(describing: citation))")
        tableView.reloadData()

        toggleCitationButton()
    }

    func toggleCitationButton() {
        if citation == nil {
            showEmptyModal()
        }
    }

    func setupInterface() {
        self.title = "Citation"
        self.view.addSubview(tableView)
    }

    func setupConstraints() {
        self.tableView.constraintToEdges(superview: self.view)
    }

    func showEmptyModal() {
        NSLog("showEmptyModal()")
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmptyViewController") as? EmptyViewController {
            self.parent?.present(vc, animated: true, completion: nil)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("DetailViewController.viewWillDisappear")
    }
}

extension DetailViewController: CitationSelectionDelegate {
    func citationSelected(_ newCitation: Citation) {
        citation = newCitation
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let citation = self.citation else {
            return 0
        }
        NSLog("citation: \(citation)")
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CitationTableViewCell(style: .default, reuseIdentifier: "CitationTableViewCell")
        if let citation = citation {
            cell.citationLabel.text = "\"\(citation.citation)\" from: \(citation.url)"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
