//
//  ShareViewController.swift
//  Citation Share Extension
//
//  Created by Doug Diego on 1/31/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    private var citationUrl: String?
    private var citationString: String?
    private var citationComment: String?

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        // Get the comment from the text view
        citationComment = textView.text

        NSLog("citationUrl: \(String(describing: citationUrl)) citationString: \(String(describing: citationString)) citationComment: \(String(describing: citationComment))")

        // Create a Citation Object and persist
        let citation = Citation()
        citation.citation = citationString ?? ""
        citation.comment = citationComment ?? ""
        citation.url = citationUrl ?? ""
        citation.created = Date()
        citation.updated = Date()
        DBManager.shared.addCitation(object: citation)

        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first {
            let propertyList = String(kUTTypePropertyList)
            if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
                itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, _) -> Void in
                    guard let dictionary = item as? NSDictionary else { return }
                    OperationQueue.main.addOperation {
                        if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                            let urlString = results["URL"] as? String { //,
                           // let url = NSURL(string: urlString){
                            self.citationUrl = urlString
                            if let selection = results["selection"] as? String {
                                self.citationString = selection
                                print("URL retrieved: \(urlString) selection: \(selection)")
                            } else {
                                print("URL retrieved: \(urlString)")
                            }
                        }
                    }
                })
            } else {
                NSLog("error")
            }
        } else {
            NSLog("error")
        }
    }
}
