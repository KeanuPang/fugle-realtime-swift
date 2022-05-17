//
//  ClientConfig.swift
//
//
//  Created by Keanu Pang on 2022/5/16.
//

import Foundation
import NIOCore

enum DefaultEnvironment: String {
    case FUGLE_API_TOKEN
    case REQUEST_TIMEOUT
    case DEALTS_PAGE_LIMIT

    case DISABLE_LOGGER

    var value: String? {
        env.get(self.rawValue)
    }
}

public struct ClientConfig {
    private static var apiToken: String?

    static var requestTimeout: TimeAmount {
        guard let value = Int64(DefaultEnvironment.REQUEST_TIMEOUT.value ?? "") else {
            return .seconds(30)
        }
        return TimeAmount.seconds(value)
    }

    static var responseMaxSize: Int {
        return 1024 * 1024 * 3 // 3 MB
    }

    static var pageLimitDealts: PAGING_LIMIT {
        guard let value = PAGING_LIMIT(DefaultEnvironment.REQUEST_TIMEOUT.value ?? ""),
              value > 0, value < 500
        else { return 50 }

        return value
    }

    static func setApiToken(_ token: String) {
        ClientConfig.apiToken = token
    }

    static func getApiToken() -> String {
        guard let token = ClientConfig.apiToken, !token.isEmpty else {
            return env.get(DefaultEnvironment.FUGLE_API_TOKEN.rawValue) ?? ""
        }

        return token
    }

    static func loggerDisabled() -> Bool {
        return env.getAsBool(DefaultEnvironment.DISABLE_LOGGER.rawValue) ?? false
    }
}
