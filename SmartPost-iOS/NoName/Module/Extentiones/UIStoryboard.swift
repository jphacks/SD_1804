//
//  UIViewController.swift
//  NoName
//
//  Created by 守谷太一 on 2018/10/20.
//  Copyright © 2018年 守谷太一. All rights reserved.
//

import UIKit
extension UIStoryboard{
    enum Storyboard: String{
        case HomeViewController
        case SearchViewController
        case NotificationViewController
        case MessageViewController
        case Talking
        case Setting
    }
    convenience init(storyboard:Storyboard,bundle:Bundle? = nil) {
        self.init(name:storyboard.rawValue,bundle:bundle)
    }
    func instantiateViewController<T:UIViewController>() -> T where T:StoryboardIdentifiable{
        let optionalViewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier)
        guard let viewController = optionalViewController as? T else {
            fatalError("something error")
        }
        return viewController
    }
}
