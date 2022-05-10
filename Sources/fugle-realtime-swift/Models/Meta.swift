//
//  Meta.swift
//
//
//  Created by Keanu Pang on 2022/5/3.
//

import Foundation
import ObjectMapper

class ResponseMetaData: MappableDataClass {
    var meta: Meta?

    override func mapping(map: Map) {
        super.mapping(map: map)

        meta <- map["data.meta"]
    }
}

class Meta: Mappable {
    var market: String?
    var nameZhTw: String?
    var industryZhTw: String?
    var priceReference: NSDecimalNumber?
    var priceHighLimit: NSDecimalNumber?
    var priceLowLimit: NSDecimalNumber?
    var canDayBuySell: Bool?
    var canDaySellBuy: Bool?
    var canShortMargin: Bool?
    var canShortLend: Bool?
    var tradingUnit: UInt64?
    var currency: String?
    var isTerminated: Bool?
    var isSuspended: Bool?
    var typeZhTw: String?
    var abnormal: String?
    var isUnusuallyRecommended: Bool?

    required init?(map: Map) {}

    func mapping(map: Map) {
        market <- map["market"]
        nameZhTw <- map["nameZhTw"]
        industryZhTw <- map["industryZhTw"]
        priceReference <- (map["priceReference"], NSDecimalNumberTransform())
        priceHighLimit <- (map["priceHighLimit"], NSDecimalNumberTransform())
        priceLowLimit <- (map["priceLowLimit"], NSDecimalNumberTransform())
        canDayBuySell <- map["canDayBuySell"]
        canDaySellBuy <- map["canDaySellBuy"]
        canShortMargin <- map["canShortMargin"]
        canShortLend <- map["canShortLend"]
        tradingUnit <- map["tradingUnit"]
        currency <- map["currency"]
        isTerminated <- map["isTerminated"]
        isSuspended <- map["isSuspended"]
        typeZhTw <- map["typeZhTw"]
        abnormal <- map["abnormal"]
        isUnusuallyRecommended <- map["isUnusuallyRecommended"]
    }
}
