//
//  ListPopupViewController.swift
//  Citation
//
//  Created by Doug Diego on 3/7/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog

class ListPopupViewController<T: UIViewController>: UINavigationController {
    var child: T {
        return self.topViewController as! T
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var popupController: PopupDialog? {
        return self.parent as? PopupDialog
    }
}

class SettingsPopupViewController: ListPopupViewController<SettingsViewController> {}
