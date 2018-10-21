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

//    public init(date: String, from: String, name: String, src1: String, src2: String, time: String, type: String, inInbox: Bool) {
//        self.date = date
//        self.from = from
//        self.name = name
//        self.src1 = src1
//        self.src2 = src2
//        self.time = time
//        self.type = type
//        self.inInbox = inInbox
//    }

    let date: String
    let from: String
    let name: String
    private let src1: String
    private let src2: String
    let time: String
    let type: String
    let inInbox: Bool
    let text1: String?
    let text2: String?

    var image1: UIImage? {
        guard let data = Data(base64Encoded: src1) else { return nil }
        return UIImage(data: data)
    }
    var image2: UIImage? {
        guard let data = Data(base64Encoded: src2) else { return nil }
        return UIImage(data: data)
    }
}
