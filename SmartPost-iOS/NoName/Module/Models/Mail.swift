//
//  Mail.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation
import UIKit
struct Mail: Codable {
    enum `Type` {
        case unknown
    }

    let date: String
    let from: String
    let name: String
    private let src: String
    let time: String
    let type: String
    let isInbox: Bool = true
    var image: UIImage? {
        guard let data = Data(base64Encoded: src) else { return nil }
        return UIImage(data: data)
    }
}
