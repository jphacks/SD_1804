//
//  Storyboard.swift
//  NoName
//
//  Created by 守谷太一 on 2018/10/20.
//  Copyright © 2018年 守谷太一. All rights reserved.
//

import UIKit
protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}
extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
