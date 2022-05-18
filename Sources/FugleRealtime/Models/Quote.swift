//
//  Quote.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

/// Quote data class for Fugle intraday endpoint
public class QuoteData: DataResource {
    public var quote: Quote?

    public static var resource: IntradayResource {
        return .quote
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)

        quote <- map["data.quote"]
    }
}

public class Quote: Mappable {
    public var isCurbing: Bool?
    public var isCurbingFall: Bool?
    public var isCurbingRise: Bool?
    public var isTrial: Bool?
    public var isDealt: Bool?
    public var isOpenDelayed: Bool?
    public var isCloseDelayed: Bool?
    public var isHalting: Bool?
    public var isClosed: Bool?

    public var total: QuoteTotal?
    public var trial: QuoteTrial?
    public var trade: QuoteTrade?
    public var order: QuoteOrder?

    public var priceHigh: QuotePrice?
    public var priceLow: QuotePrice?
    public var priceOpen: QuotePrice?
    public var priceAvg: QuotePrice?

    public var change: NSDecimalNumber?
    public var changePercent: NSDecimalNumber?
    public var amplitude: NSDecimalNumber?
    public var priceLimit: UInt8?

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

    public class QuoteTotal: Mappable {
        public var at: String?
        public var transaction: UInt64?
        public var tradeValue: NSDecimalNumber?
        public var tradeVolume: UInt64?
        public var tradeVolumeAtBid: UInt64?
        public var tradeVolumeAtAsk: UInt64?
        public var bidOrders: UInt64?
        public var askOrders: UInt64?
        public var bidVolume: UInt64?
        public var askVolume: UInt64?
        public var serial: UInt64?

        public required init?(map: Map) {}

        public func mapping(map: Map) {
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

    public class QuoteTrial: Mappable {
        public var at: String?
        public var bid: NSDecimalNumber?
        public var ask: NSDecimalNumber?
        public var price: NSDecimalNumber?
        public var volume: UInt64?

        public required init?(map: Map) {}

        public func mapping(map: Map) {
            at <- map["at"]
            bid <- (map["bid"], NSDecimalNumberTransform())
            ask <- (map["ask"], NSDecimalNumberTransform())
            price <- (map["price"], NSDecimalNumberTransform())
            volume <- map["volume"]
        }
    }

    public class QuoteTrade: Mappable {
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

    public class QuoteOrder: Mappable {
        public var at: String?
        public var bids = [Volumes]()
        public var asks = [Volumes]()

        public required init?(map: Map) {}

        public func mapping(map: Map) {
            at <- map["at"]
            bids <- map["bids"]
            asks <- map["asks"]
        }
    }

    public class QuotePrice: Mappable {
        public var price: NSDecimalNumber?
        public var at: String?

        public required init?(map: Map) {}

        public func mapping(map: Map) {
            price <- (map["price"], NSDecimalNumberTransform())
            at <- map["at"]
        }
    }
}
