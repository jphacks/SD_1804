//
//  APIClient.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Cache

class APIClient {
    private let baseURL: URL
    private let pathExtension: String
    private let cache: Storage<Mail> = {
        let diskConfig = DiskConfig(name: "Floppy")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
        let storage = try! Storage(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: Mail.self)
        )
        return storage
    }()

    public init(configuration: APIConfiguration = .default) {
        self.baseURL = configuration.baseURL
        self.pathExtension = configuration.pathExtension
    }

    public func response<Request>(from request: Request) -> Single<Request.Response>
        where Request: APIRequest, Request.Response: Codable {
            return Single<Request.Response>.create { [unowned self] (emitter) -> Disposable in

                let url = self.baseURL
                    .appendingPathComponent(request.path)
                    .appendingPathComponent(self.pathExtension)

                let req = Alamofire.request(url, method: request.method, parameters: request.parameters,
                                                encoding: request.encoding, headers: request.headers)

                debugLog(req.debugDescription)

                req.response { response in
                    debugLog("Status: \(response.response?.statusCode ?? -1)")

                    if let error = response.error { emitter(.error(error)) }
                    if let data = response.data {
                        do {
                            let response = try JSONDecoder().decode(Request.Response.self, from: data)

                            // CACHE
                            let transformer = TransformerFactory.forCodable(ofType: Request.Response.self)
                            let storage = self.cache.transform(transformer: transformer)
                            try! storage.setObject(response, forKey: request.cacheKey)

                            emitter(.success(response))
                        } catch {
                            emitter(.error(error))
                        }
                    }
                    emitter(.error(AppError.unknown))
                }
                return Disposables.create()
            }
    }
}
