//
//  Mail.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation
import UIKit

struct Mail {
    enum `Type` {
        case unknown
    }

    public init(date: String, from: String, name: String, src: String, time: String, type: String, inInbox: Bool) {
        self.date = date
        self.from = from
        self.name = name
        self.src = src
        self.time = time
        self.type = type
        self.inInbox = inInbox
    }

    let date: String
    let from: String
    let name: String
    private let src: String
    let time: String
    let type: String
    let inInbox: Bool

    var image: UIImage? {
        guard let data = Data(base64Encoded: src) else { return nil }
        return UIImage(data: data)
    }
}

extension Mail: Codable {
}
