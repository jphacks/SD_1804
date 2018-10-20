//
//  APIRequest.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRequest {
    associatedtype Response
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}

extension APIRequest {
    var encoding: ParameterEncoding { return URLEncoding.default }
    var headers: HTTPHeaders? { return nil }
}

// extensionでリクエストを追加していく
struct APIRequests {}
