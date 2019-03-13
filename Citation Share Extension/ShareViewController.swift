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
import os.log
import RealmSwift

class ShareViewController: SLComposeServiceViewController {
    private let log = OSLog(category: "ShareViewController")
    private var citationUrl: String?
    private var citationTitle: String?
    private var citationString: String?
    private var citationHTMLString: String?
    private var citationComment: String?
    private var citationTags: [Tag]? = []

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        // Get the comment from the text view
        citationComment = textView.text

        log.debug("citationUrl: %s citationString: %s citationComment: %s citationTitle: %s",
                  String(describing: citationUrl), String(describing: citationString),
                  String(describing: citationComment), String(describing: citationTitle))

        // Create a Citation Object and persist
        let citation = Citation()
        citation.citation = citationString ?? ""
        citation.citationHtml = citationHTMLString ?? ""
        citation.comment = citationComment ?? ""
        citation.url = citationUrl ?? ""
        citation.title = citationTitle ?? ""
        citation.created = Date()
        citation.updated = Date()
        if let citationTags = citationTags {
            for tag in citationTags {
                citation.tags.append(tag)
            }
        }

        DBManager.shared.addCitation(object: citation)

        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        log.debug("configurationItems()")
        if let deck = SLComposeSheetConfigurationItem() {
            deck.title = "Tags"
            if let citationTags = citationTags, citationTags.count > 0 {
                let tags = citationTags.map {$0.tag}
                deck.value = tags.joined(separator: ", ")
            } else {
                deck.value = ""
            }
            deck.tapHandler = {
                let vm = TagViewModel()
                vm.tagView = .user
                if let citationTags = self.citationTags, citationTags.count > 0 {
                    vm.selectedTags = citationTags
                }
                let vc = TagViewController(viewModel: vm)
                vc.delegate = self
                self.pushConfigurationViewController(vc)
            }
            return [deck]
        }
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
                                self.log.debug("URL retrieved: %s selection: %s", urlString, selection)
                            } else {
                                self.log.debug("URL retrieved: %s", urlString)
                            }

                            if let selectionHtml = results["selectionHtml"] as? String {
                                self.citationHTMLString = selectionHtml
                                self.log.debug("selectionHtml: %s", selectionHtml)
                            }

                            if let title = results["title"] as? String {
                                self.citationTitle = title
                                self.log.debug("title: %s", title)
                            }
                        }
                    }
                })
            } else {
                log.error("error")
            }
        } else {
            log.error("error")
        }
    }
}

extension ShareViewController: TagViewControllerDelegate {
    func selectedTags(tags: [Tag]?) {
        log.debug("selectedTags() tags: %s", String(describing: tags))
        self.citationTags = tags
        reloadConfigurationItems() // calls configurationItems
    }
}
