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
import PINCache

class APIClient {
    let baseURL: URL
    let pathExtension: String
    public init(configuration: APIConfiguration = .default) {
        self.baseURL = configuration.baseURL
        self.pathExtension = configuration.pathExtension
    }

    public func response<Request>(from request: Request) -> Single<Request.Response>
        where Request: APIRequest, Request.Response: Decodable {
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

                            // CACHE FIXME
//                            if let nsCodingResponse = response as? NSCoding {
//                                self.saveCache(request: request, response: nsCodingResponse)
//                            }

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

    private func saveCache<Request>(request: Request, response: NSCoding)
        where Request: APIRequest {
        PINCache.shared().setObject(response, forKey: request.cacheKey)
    }
}
