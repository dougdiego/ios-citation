//
//  DetailViewController.swift
//  Citation
//
//  Created by Doug Diego on 2/5/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit
import SafariServices
import os.log

class DetailViewController: UIViewController {

    var viewModel: DetailViewModel = DetailViewModel()
    private let log = OSLog(category: "DetailViewController")

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
                           forCellReuseIdentifier: "citationCell")
        tableView.register(CitationTableViewCell.self,
                           forCellReuseIdentifier: "urlCell")
        tableView.register(DividerTableViewCell.self,
                           forCellReuseIdentifier: "dividerCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log.debug("DetailViewController.viewWillAppear() citation: %s", String(describing: self.viewModel.citation))
        tableView.reloadData()
        checkForEmpty()
    }

    func checkForEmpty() {
        if !self.viewModel.hasCitation() {
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
        log.debug("showEmptyModal()")
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmptyViewController") as? EmptyViewController {
            self.parent?.present(vc, animated: true, completion: nil)
        }
    }

    func setCitation(_ citation: Citation) {
        self.viewModel.citation = citation
        self.tableView.reloadData()
        checkForEmpty()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        log.debug("DetailViewController.viewWillDisappear")
    }

    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("common_ok", comment: ""),
                                     style: .cancel) { (_) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension DetailViewController {

    @IBAction func showCitationActionSheet(sourceRect: CGRect) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let copyTextAction = UIAlertAction(title: "Copy text to clipboard", style: .default, handler: { (_: UIAlertAction!) -> Void in
            if let citation = self.viewModel.citation?.citation {
                let pasteboard = UIPasteboard.general
                pasteboard.string = citation
                self.showAlert(title: nil, message: "Copied text to clipboard")
            } else {
                self.showAlert(title: nil, message: "Nothing to copy")
            }
        })

        let copyHtmlAction = UIAlertAction(title: "Copy HTML to clipboard", style: .default, handler: { (_: UIAlertAction!) -> Void in
            if let citationHtml = self.viewModel.citation?.citationHtml {
                let pasteboard = UIPasteboard.general
                pasteboard.string = citationHtml
                self.showAlert(title: nil, message: "Copied HTML to clipboard")
            } else {
                self.showAlert(title: nil, message: "Nothing to copy")
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(copyTextAction)
        alertController.addAction(copyHtmlAction)
        alertController.addAction(cancelAction)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = tableView
            popoverController.sourceRect = sourceRect
        }

        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func showUrlActionSheet(sourceRect: CGRect) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let openAction = UIAlertAction(title: "Open Link", style: .default, handler: { (_: UIAlertAction!) -> Void in
            if let citationUrl = self.viewModel.citation?.url, let url = URL(string: citationUrl) {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
            }
        })

        let copyAction = UIAlertAction(title: "Copy to clipboard", style: .default, handler: { (_: UIAlertAction!) -> Void in
            if let citationUrl = self.viewModel.citation?.url {
                let pasteboard = UIPasteboard.general
                pasteboard.string = citationUrl
                self.showAlert(title: nil, message: "Copied \(citationUrl) to clipboard")
            } else {
                self.showAlert(title: nil, message: "Nothing to copy")
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(openAction)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = tableView
            popoverController.sourceRect = sourceRect
        }

        self.present(alertController, animated: true, completion: nil)
    }
}

extension DetailViewController: CitationSelectionDelegate {
    func citationSelected(_ newCitation: Citation) {
        setCitation(newCitation)
    }
}

extension DetailViewController {
    func citationCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = CitationTableViewCell(style: .default, reuseIdentifier: "citationCell")
        cell.citationLabel.text = self.viewModel.valueForCell(atIndexPath: indexPath)
        return cell
    }

    func urlCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = CitationTableViewCell(style: .default, reuseIdentifier: "urlCell")
        if let value = self.viewModel.valueForCell(atIndexPath: indexPath) {
            let attributedText = NSMutableAttributedString(string: value)
            attributedText.linkAttributes(terms: [value as NSString], linkColor: UIColor(named: "Theme") ?? .blue )
            cell.citationLabel.attributedText = attributedText
        }
        return cell
    }

    func dividerCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = DividerTableViewCell(style: .default, reuseIdentifier: "dividerCell")
        cell.selectionStyle = .none
        return cell
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = DetailViewModel.Rows(rawValue: indexPath.row) else { return UITableViewCell() }
        switch row {
        case .citation:
            return citationCell(indexPath)
        case .url:
            return urlCell(indexPath)
        case .comment:
            return citationCell(indexPath)
        case .divider1:
            return dividerCell(indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let row = DetailViewModel.Rows(rawValue: indexPath.row) else { return }
        switch row {
        case .citation:
            showCitationActionSheet(sourceRect: tableView.cellForRow(at: indexPath)!.frame)
        case .url:
            showUrlActionSheet(sourceRect: tableView.cellForRow(at: indexPath)!.frame)
        default:
            log.debug("do nothing")
        }
    }
}
