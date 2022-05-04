//
//  Constants.swift
//
//
//  Created by Keanu Pang on 2022/5/3.
//

import Foundation
import NIOCore

let FUGLE_ENDPOINT_INTRADAY = "https://api.fugle.tw/realtime/v0.3/intraday"
let FUGLE_ENDPOINT_MARKETDATA = "https://api.fugle.tw/marketdata/v0.3/candles"

let DEFAULT_REQUEST_TIMEOUT: TimeAmount = .seconds(30)
let DEFAULT_RESPONSE_MAX_SIZE = 1024 * 1024 * 3 // 3 MB

typealias PAGING_LIMIT = UInt
typealias PAGING_OFFSET = UInt

enum IntradayResource {
    case chart
    case quote
    case meta
    case dealts(PAGING_LIMIT, PAGING_OFFSET)
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

enum IntradayParameters: String, CaseIterable {
    case symbolId
    case apiToken
    case oddLot
}

enum IntradayParametersPaging: String, CaseIterable {
    case limit
    case offset
}

enum CandleParameters: String, CaseIterable {
    case symbolId
    case apiToken
    case from
    case to
}
