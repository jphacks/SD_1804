//
//  MailRepository.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation
import RxSwift

class MailRepository {
    private let api = APIClient(configuration: .default)

    func fetchAllMails() -> Observable<[Mail]> {
        return api.response(from: APIRequests.GetAllMailsRequest(userId: 1))
            .asObservable()
            .map { Array($0.values) }
    }

    func search() {
    }
}
