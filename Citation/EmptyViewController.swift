//
//  EmptyViewController.swift
//  Citation
//
//  Created by Doug Diego on 2/7/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iPhoneImageAspectConstraint: NSLayoutConstraint!
    @IBOutlet weak var iPadImageAspectConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("EmptyViewController.viewDidLoad")
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageView.image = UIImage(named: "ipad1")
            imageView.removeConstraint(iPhoneImageAspectConstraint)
        } else {
            imageView.removeConstraint(iPadImageAspectConstraint)
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissEmptyModal(notification:)),
                                               name: .dismissEmptyModal,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("EmptyViewController.viewWillDisappear")
    }

    @objc func dismissEmptyModal(notification: NSNotification) {
        NSLog("dismissEmptyModal()  notification: %s", String(describing: notification))
        self.dismiss(animated: false, completion: nil)
    }
}
