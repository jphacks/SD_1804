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

    public init(date: String, from: String, name: String, src1: String, src2: String, time: String, type: String, inInbox: Bool) {
        self.date = date
        self.from = from
        self.name = name
        self.src1 = src1
        self.src2 = src2
        self.time = time
        self.type = type
        self.inInbox = inInbox
    }

    private enum CodingKeys: String, CodingKey {
        case date
        case from
        case name
        case src1
        case src2
        case time
        case type
        case inInbox
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(from, forKey: .from)
        try container.encode(name, forKey: .name)
        try container.encode(src1, forKey: .src1)
        try container.encode(src2, forKey: .src2)
        try container.encode(time, forKey: .time)
        try container.encode(type, forKey: .type)
        try container.encode(type, forKey: .type)
        try container.encode(inInbox, forKey: .inInbox)
    }

    let date: String
    let from: String
    let name: String
    private let src1: String
    private let src2: String
    let time: String
    let type: String
    let inInbox: Bool

    var image1: UIImage? {
        guard let data = Data(base64Encoded: src1) else { return nil }
        return UIImage(data: data)
    }
    var image2: UIImage? {
        guard let data = Data(base64Encoded: src2) else { return nil }
        return UIImage(data: data)
    }
}

extension Mail {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(String.self, forKey: .date)
        from = try values.decode(String.self, forKey: .from)
        name = try values.decode(String.self, forKey: .name)
        src1 = try values.decode(String.self, forKey: .src1)
        src2 = try values.decode(String.self, forKey: .src2)
        time = try values.decode(String.self, forKey: .time)
        type = try values.decode(String.self, forKey: .type)
        inInbox = try values.decode(Bool.self, forKey: .inInbox)
    }
}
