//
//  AppDelegate.swift
//  NoName
//
//  Created by 守谷太一 on 2018/10/20.
//  Copyright © 2018年 守谷太一. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var searchViewController: SearchViewController!
    var tab: UITabBarController!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let tabBarController = UITabBarController()
        let vc1: MailListViewController = {
            let vc = ViewController.instantiate(MailListViewController.self)
            vc.tabBarItem = UITabBarItem(title: "マイポスト", image: R.image.postIt()!, selectedImage: nil)
            return vc
        }()
        let vc2: SearchViewController = {
            let vc = ViewController.instantiate(SearchViewController.self)
            vc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
            vc.title = "検索"
            return vc
        }()
        searchViewController = vc2
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: vc1),
            UINavigationController(rootViewController: vc2)
        ]

        self.tab = tabBarController
        tabBarController.tabBar.tintColor = .red
        window?.rootViewController = tabBarController

//        let notificationSettings = UIUserNotificationSettings(
//            types: [.badge, .sound, .alert], categories: nil
//        )
//        application.registerUserNotificationSettings(notificationSettings)
        FirebaseApp.configure()

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }

        // Print full message.
        print(userInfo)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        debugLog(messaging, remoteMessage)
    }
}
