//
//  Dealts.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

public class DealtsData: DataResource {
    public var dealts = [Dealts]()

    public static var resource: IntradayResource {
        return .dealts(ClientConfig.pageLimitDealts, 0)
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)

        dealts <- map["data.dealts"]
    }
}

public class Dealts: Mappable {
    public var at: String?
    public var bid: NSDecimalNumber?
    public var ask: NSDecimalNumber?
    public var price: NSDecimalNumber?
    public var volume: UInt64?
    public var serial: UInt64?

    public required init?(map: Map) {}

    public func mapping(map: Map) {
        at <- map["at"]
        bid <- (map["bid"], NSDecimalNumberTransform())
        ask <- (map["ask"], NSDecimalNumberTransform())
        price <- (map["price"], NSDecimalNumberTransform())
        volume <- map["volume"]
        serial <- map["serial"]
    }
}
