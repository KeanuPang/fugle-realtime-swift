//
//  Quote.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

public class ResponseQuoteData: MappableDataClass {
    var quote: Quote?

    override public func mapping(map: Map) {
        super.mapping(map: map)

        quote <- map["data.quote"]
    }
}

public class Quote: Mappable {
    var isCurbing: Bool?
    var isCurbingFall: Bool?
    var isCurbingRise: Bool?
    var isTrial: Bool?
    var isDealt: Bool?
    var isOpenDelayed: Bool?
    var isCloseDelayed: Bool?
    var isHalting: Bool?
    var isClosed: Bool?

    var total: QuoteTotal?
    var trial: QuoteTrial?
    var trade: QuoteTrade?
    var order: QuoteOrder?

    var priceHigh: QuotePrice?
    var priceLow: QuotePrice?
    var priceOpen: QuotePrice?
    var priceAvg: QuotePrice?

    var change: NSDecimalNumber?
    var changePercent: NSDecimalNumber?
    var amplitude: NSDecimalNumber?
    var priceLimit: UInt8?

    public required init?(map: Map) {}

    public func mapping(map: Map) {
        isCurbing <- map["isCurbing"]
        isCurbingFall <- map["isCurbingFall"]
        isCurbingRise <- map["isCurbingRise"]
        isTrial <- map["isTrial"]
        isDealt <- map["isDealt"]
        isOpenDelayed <- map["isOpenDelayed"]
        isCloseDelayed <- map["isCloseDelayed"]
        isHalting <- map["isHalting"]
        isClosed <- map["isClosed"]
        total <- map["total"]
        trial <- map["trial"]
        trade <- map["trade"]
        order <- map["order"]
        priceHigh <- map["priceHigh"]
        priceLow <- map["priceLow"]
        priceOpen <- map["priceOpen"]
        priceAvg <- map["priceAvg"]
        change <- (map["change"], NSDecimalNumberTransform())
        changePercent <- (map["changePercent"], NSDecimalNumberTransform())
        amplitude <- (map["amplitude"], NSDecimalNumberTransform())
        priceLimit <- map["priceLimit"]
    }

    class QuoteTotal: Mappable {
        var at: String?
        var transaction: UInt64?
        var tradeValue: NSDecimalNumber?
        var tradeVolume: UInt64?
        var tradeVolumeAtBid: UInt64?
        var tradeVolumeAtAsk: UInt64?
        var bidOrders: UInt64?
        var askOrders: UInt64?
        var bidVolume: UInt64?
        var askVolume: UInt64?
        var serial: UInt64?

        required init?(map: Map) {}

        func mapping(map: Map) {
            at <- map["at"]
            transaction <- map["transaction"]
            tradeValue <- (map["tradeValue"], NSDecimalNumberTransform())
            tradeVolume <- map["tradeVolume"]
            tradeVolumeAtBid <- map["tradeVolumeAtBid"]
            tradeVolumeAtAsk <- map["tradeVolumeAtAsk"]
            bidOrders <- map["bidOrders"]
            askOrders <- map["askOrders"]
            bidVolume <- map["bidVolume"]
            askVolume <- map["askVolume"]
            serial <- map["serial"]
        }
    }

    class QuoteTrial: Mappable {
        var at: String?
        var bid: NSDecimalNumber?
        var ask: NSDecimalNumber?
        var price: NSDecimalNumber?
        var volume: UInt64?

        required init?(map: Map) {}

        func mapping(map: Map) {
            at <- map["at"]
            bid <- (map["bid"], NSDecimalNumberTransform())
            ask <- (map["ask"], NSDecimalNumberTransform())
            price <- (map["price"], NSDecimalNumberTransform())
            volume <- map["volume"]
        }
    }

    class QuoteTrade: Mappable {
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

    class QuoteOrder: Mappable {
        var at: String?
        var bids = [Volumes]()
        var asks = [Volumes]()

        required init?(map: Map) {}

        func mapping(map: Map) {
            at <- map["at"]
            bids <- map["bids"]
            asks <- map["asks"]
        }
    }

    class QuotePrice: Mappable {
        var price: NSDecimalNumber?
        var at: String?

        required init?(map: Map) {}

        func mapping(map: Map) {
            price <- (map["price"], NSDecimalNumberTransform())
            at <- map["at"]
        }
    }
}
