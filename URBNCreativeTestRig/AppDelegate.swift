//
//  AppDelegate.swift
//  URBNCreativeTestRig
//
//  Created by Jason Grandelli on 11/9/15.
//  Copyright © 2015 Jason Grandelli. All rights reserved.
//

import UIKit

import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("d605479e1a864ce28cc26f5dc329849a")
        BITHockeyManager.sharedHockeyManager().startManager()
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
        BITHockeyManager.sharedHockeyManager().disableCrashManager = false
        

        
        let masterVC = MasterViewController(style: UITableViewStyle.Plain)
        let masterNavVC = UINavigationController(rootViewController: masterVC)
        let detailVC = UINavigationController(rootViewController: BaseDetailViewController())
        masterVC.detailViewController = detailVC
        
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [masterNavVC, detailVC]
        splitViewController.delegate = self
        splitViewController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible

        window = UIWindow()
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        return true
    }

}

