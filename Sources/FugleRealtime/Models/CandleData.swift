//
//  CandleData.swift
//
//
//  Created by Keanu Pang on 2022/5/3.
//

import Foundation
import ObjectMapper

public class ResponseCandleData: Mappable {
    var symbolId: String?
    var type: String?
    var exchange: String?
    var market: String?

    var candles = [CandleData]()

    public required init?(map: Map) {}

    public func mapping(map: Map) {
        symbolId <- map["symbolId"]
        type <- map["type"]
        exchange <- map["exchange"]
        market <- map["market"]
        candles <- map["candles"]
    }
}

public class CandleData: Mappable {
    var date: String?
    var open: NSDecimalNumber?
    var high: NSDecimalNumber?
    var low: NSDecimalNumber?
    var close: NSDecimalNumber?
    var volume: UInt64?

    public required init?(map: Map) {}

    public func mapping(map: Map) {
        date <- map["date"]
        open <- (map["open"], NSDecimalNumberTransform())
        high <- (map["high"], NSDecimalNumberTransform())
        low <- (map["low"], NSDecimalNumberTransform())
        close <- (map["close"], NSDecimalNumberTransform())
        volume <- map["volume"]
    }
}
