//
//  AppDelegate.swift
//  NoName
//
//  Created by 守谷太一 on 2018/10/20.
//  Copyright © 2018年 守谷太一. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let tabBarController = UITabBarController()
        let vc1 = UIViewController.instantiate(with: .MailListViewController)
        vc1.title = "一覧"
        let vc2 = UIViewController.instantiate(with: .SearchViewController)
        vc2.title = "検索"
        tabBarController.viewControllers = [vc1, vc2]

        window?.rootViewController = UINavigationController(
            rootViewController: tabBarController
        )

        return true
    }}

