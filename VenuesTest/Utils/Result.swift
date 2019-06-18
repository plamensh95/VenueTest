//
//  Result.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

import Foundation

enum Result {
    case success(Any)
    case failure(CustomError)
}

enum CustomError: Error {
    case couldntReach
    case couldntParse
    case quotaExceeded
    case error(Error)
    case other(String)
}

extension CustomError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .couldntReach:
            return Message.kReachServerError
        case .couldntParse:
            return Message.kParseServerResponseError
        case .quotaExceeded:
            return Message.kQuotaExceeded
        case .error(let error):
            return error.localizedDescription
        case .other(let message):
            return message
        }
    }
}
