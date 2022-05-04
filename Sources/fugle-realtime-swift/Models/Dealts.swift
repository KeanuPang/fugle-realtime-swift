//
//  Dealts.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

class ResponseDealtsData: Mappable {
    var apiVersion: String?
    var info: Info?
    var dealts = [Dealts]()

    required init?(map: Map) {}

    func mapping(map: Map) {
        apiVersion <- map["apiVersion"]
        info <- map["data.info"]
        dealts <- map["data.dealts"]
    }
}

class Dealts: Mappable {
    var at: String?
    var bid: NSDecimalNumber?
    var ask: NSDecimalNumber?
    var price: NSDecimalNumber?
    var volume: UInt64?
    var serial: UInt64?

    required init?(map: Map) {}

    func mapping(map: Map) {
        at <- map["at"]
        bid <- (map["bid"], NSDecimalNumberTransform())
        ask <- (map["ask"], NSDecimalNumberTransform())
        price <- (map["price"], NSDecimalNumberTransform())
        volume <- map["volume"]
        serial <- map["serial"]
    }
}
