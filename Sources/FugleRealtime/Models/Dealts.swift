//
//  Dealts.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

public class ResponseDealtsData: MappableDataClass {
    var dealts = [Dealts]()

    override public func mapping(map: Map) {
        super.mapping(map: map)

        dealts <- map["data.dealts"]
    }
}

public class Dealts: Mappable {
    var at: String?
    var bid: NSDecimalNumber?
    var ask: NSDecimalNumber?
    var price: NSDecimalNumber?
    var volume: UInt64?
    var serial: UInt64?

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
