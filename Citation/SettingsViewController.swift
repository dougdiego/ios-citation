//
//  SettingsViewController.swift
//  Citation
//
//  Created by Doug Diego on 3/7/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tempView()
    }

    private lazy var tempLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor(named: "Theme")
        label.text = "Comming Soon!"
        label.enableAutoLayout()
        return label
    }()

    func tempView() {
        self.view.addSubview(tempLabel)
        self.tempLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        self.tempLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
