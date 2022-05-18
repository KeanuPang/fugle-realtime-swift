//
//  Meta.swift
//
//
//  Created by Keanu Pang on 2022/5/3.
//

import Foundation
import ObjectMapper

/// Meta data class for Fugle intraday endpoint
open class MetaData: DataResource {
    public var meta: Meta?

    public static var resource: IntradayResource {
        return .meta
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)

        meta <- map["data.meta"]
    }
}

open class Meta: Mappable {
    public var market: String?
    public var nameZhTw: String?
    public var industryZhTw: String?
    public var priceReference: NSDecimalNumber?
    public var priceHighLimit: NSDecimalNumber?
    public var priceLowLimit: NSDecimalNumber?
    public var canDayBuySell: Bool?
    public var canDaySellBuy: Bool?
    public var canShortMargin: Bool?
    public var canShortLend: Bool?
    public var tradingUnit: UInt64?
    public var currency: String?
    public var isTerminated: Bool?
    public var isSuspended: Bool?
    public var typeZhTw: String?
    public var abnormal: String?
    public var isUnusuallyRecommended: Bool?

    public required init?(map: Map) {}

    public func mapping(map: Map) {
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
