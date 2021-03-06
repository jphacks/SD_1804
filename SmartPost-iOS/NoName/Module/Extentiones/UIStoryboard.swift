//
//  UIViewController.swift
//  NoName
//
//  Created by 守谷太一 on 2018/10/20.
//  Copyright © 2018年 守谷太一. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum ViewController {
    static func instantiate<ViewController: UIViewController>(_ type: ViewController.Type) -> ViewController {
        let name = String(describing: ViewController.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateInitialViewController() as! ViewController
    }
}


extension UIViewController: NVActivityIndicatorViewable {
    func startLoading() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
