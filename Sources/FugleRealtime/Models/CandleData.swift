//
//  CandleData.swift
//
//
//  Created by Keanu Pang on 2022/5/3.
//

import Foundation
import ObjectMapper

public class CandleData: Mappable {
    public var symbolId: String?
    public var type: String?
    public var exchange: String?
    public var market: String?

    public var candles = [CandleDetails]()

    public required init?(map: Map) {}

    public func mapping(map: Map) {
        symbolId <- map["symbolId"]
        type <- map["type"]
        exchange <- map["exchange"]
        market <- map["market"]
        candles <- map["candles"]
    }
}

public class CandleDetails: Mappable {
    public var date: String?
    public var open: NSDecimalNumber?
    public var high: NSDecimalNumber?
    public var low: NSDecimalNumber?
    public var close: NSDecimalNumber?
    public var volume: UInt64?

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
