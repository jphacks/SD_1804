//
//  APIConfiguration.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation

struct APIConfiguration {
    let baseURL: URL
    let pathExtension: String

    static let `default`: APIConfiguration = APIConfiguration(
        baseURL: URL(string: "https://us-central1-smart-post-tol.cloudfunctions.net")!,
        pathExtension: ""
    )
}
