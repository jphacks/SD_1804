//
//  MailRepository.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation
import RxSwift
import PINCache

class MailRepository {
    private let api = APIClient(configuration: .default)

    func fetchAllMails() -> Observable<[Mail]> {
        let request = APIRequests.GetAllMailsRequest(userId: 1)

        let cache = PINCache.shared().object(forKey: request.cacheKey) as? [Mail]

        return api.response(from: request)
            .asObservable()
            .map { Array($0.values) }
            .startWith(cache ?? [])
    }

    func search() {
    }
}
