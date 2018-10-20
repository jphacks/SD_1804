//
//  MailRepository.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation
import RxSwift
import Cache

class MailRepository {
    private let api = APIClient(configuration: .default)
    private let cache: Storage<[String:Mail]> = {
        let diskConfig = DiskConfig(name: "Floppy")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
        let storage = try! Storage(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: [String:Mail].self)
        )
        return storage
    }()

    func fetchAllMails() -> Observable<[Mail]> {
        let request = APIRequests.GetAllMailsRequest(userId: 1)

        let cache = try! self.cache.object(forKey: request.cacheKey)
            .map { $0.value }

        return api.response(from: request)
            .asObservable()
            .map { Array($0.values) }
            .startWith(cache)
    }

    func search() {
    }
}
