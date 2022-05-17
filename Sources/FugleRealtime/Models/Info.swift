//
//  Info.swift
//
//
//  Created by Keanu Pang on 2022/5/3.
//

import Foundation
import ObjectMapper

public protocol MappableData: Mappable {
    var apiVersion: String? { get set }
    var info: Info? { get set }
}

public protocol ResourceType: MappableData {
    static var resource: IntradayResource { get }
}

open class MappableDataClass: MappableData {
    public var apiVersion: String?
    public var info: Info?

    public required init?(map: Map) {}

    public func mapping(map: Map) {
        apiVersion <- map["apiVersion"]
        info <- map["data.info"]
    }
}

public class Info: MappableDataClass {
    public var date: String = ""
    public var type: String = ""
    public var exchange: String = ""
    public var market: String = ""
    public var symbolId: String = ""
    public var countryCode: String = ""
    public var timeZone: String = ""
    public var lastUpdatedAt: String?

    override public func mapping(map: Map) {
        super.mapping(map: map)

        date <- map["date"]
        type <- map["type"]
        exchange <- map["exchange"]
        market <- map["market"]
        symbolId <- map["symbolId"]
        countryCode <- map["countryCode"]
        timeZone <- map["timeZone"]
        lastUpdatedAt <- map["lastUpdatedAt"]
    }
}
