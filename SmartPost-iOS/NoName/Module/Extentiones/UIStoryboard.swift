//
//  UIViewController.swift
//  NoName
//
//  Created by 守谷太一 on 2018/10/20.
//  Copyright © 2018年 守谷太一. All rights reserved.
//

import UIKit

enum ViewController: String{
    case HomeViewController
    case MailListViewController
    case SearchViewController
    case DetailViewController
}

extension UIViewController {
    static func instantiate(with storyboard: ViewController) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
}
