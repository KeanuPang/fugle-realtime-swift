//
//  Constants.swift
//
//
//  Created by Keanu Pang on 2022/5/3.
//

import Foundation
import NIOCore

let ENDPOINT_VERSION = "v0.3"
let ENDPOINT_DOMAIN = "api.fugle.tw"

enum ENDPOINT_METHOD: String {
    case HTTP = "https://"
    case WEB_SOCKET = "wss://"

    var intraDayURL: String {
        return "\(self.rawValue)\(ENDPOINT_DOMAIN)/realtime/\(ENDPOINT_VERSION)/intraday"
    }

    var marketDataURL: String {
        return "\(self.rawValue)\(ENDPOINT_DOMAIN)/marketdata/\(ENDPOINT_VERSION)/candles"
    }
}

public typealias PAGING_LIMIT = UInt
public typealias PAGING_OFFSET = UInt

public enum IntradayResource {
    case chart
    case quote
    case meta
    case dealts(PAGING_LIMIT = 50, PAGING_OFFSET = 0)
    case volumes

    var name: String {
        switch self {
        case .chart:
            return "chart"
        case .quote:
            return "quote"
        case .meta:
            return "meta"
        case .dealts:
            return "dealts"
        case .volumes:
            return "volumes"
        }
    }

    var pagingParameters: String? {
        switch self {
        case .dealts(let limit, let offset):
            return "limit=\(limit)&offset=\(offset)"
        default:
            return nil
        }
    }
}

public enum IntradayParameters: String, CaseIterable {
    case symbolId
    case apiToken
    case oddLot
}

public enum CandleParameters: String, CaseIterable {
    case symbolId
    case apiToken
    case from
    case to
}
