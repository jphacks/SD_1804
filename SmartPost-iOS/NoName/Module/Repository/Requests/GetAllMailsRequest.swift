//
//  GetAllMailsRequest.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation
import Alamofire

extension APIRequests {
    struct GetAllMailsRequest {
        let userId: Int
    }
}

extension APIRequests.GetAllMailsRequest: APIRequest {
    typealias Response = [String: Mail]

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/getImages"
    }

    var parameters: Parameters? {
        return [
            "id": userId
        ]
    }
}
