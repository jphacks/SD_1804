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
        let vc1: MailListViewController = {
            let vc = ViewController.instantiate(MailListViewController.self)
            vc.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
            vc.title = "マイポスト"
            return vc
        }()
        let vc2: SearchViewController = {
            let vc = ViewController.instantiate(SearchViewController.self)
            vc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
            vc.title = "検索"
            return vc
        }()
        tabBarController.viewControllers = [vc1, vc2]

        window?.rootViewController = UINavigationController(
            rootViewController: tabBarController
        )

        return true
    }}

