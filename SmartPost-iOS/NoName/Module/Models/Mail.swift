//
//  Mail.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation

struct Mail: Codable {
    enum `Type` {
        case unknown
    }

    let date: Date
    let imageUrl: String
    let type: String
}
