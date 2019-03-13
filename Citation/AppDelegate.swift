//
//  AppDelegate.swift
//  Citation
//
//  Created by Doug Diego on 1/31/19.
//  Copyright © 2019 Doug Diego. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        customizeInterface()

        guard let splitViewController = window?.rootViewController as? UISplitViewController,
            let leftNavController = splitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? MasterViewController,
            let rightNavController = splitViewController.viewControllers.last as? UINavigationController,
            let detailViewController = rightNavController.topViewController as? DetailViewController
            else { fatalError() }

        let citations = DBManager.shared.getCitations()
        if citations.count > 0 {
            detailViewController.setCitation(citations[0])
        }

        masterViewController.delegate = detailViewController

        detailViewController.navigationItem.leftItemsSupplementBackButton = true
        detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //        for window in application.windows {
        //            window.rootViewController?.beginAppearanceTransition(false, animated: false)
        //            window.rootViewController?.endAppearanceTransition()
        //        }
        NotificationCenter.default.post(name: .dismissEmptyModal,
                                        object: nil,
                                        userInfo: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //        for window in application.windows {
        //            window.rootViewController?.beginAppearanceTransition(true, animated: false)
        //            window.rootViewController?.endAppearanceTransition()
        //        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func customizeInterface() {
        UINavigationBar.appearance().tintColor = UIColor(named: "Theme")
    }

}
