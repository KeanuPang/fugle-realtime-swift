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

public class MappableDataClass: MappableData {
    public var apiVersion: String?
    public var info: Info?

    public required init?(map: Map) {}

    public func mapping(map: Map) {
        apiVersion <- map["apiVersion"]
        info <- map["data.info"]
    }
}

public class Info: MappableDataClass {
    var date: String = ""
    var type: String = ""
    var exchange: String = ""
    var market: String = ""
    var symbolId: String = ""
    var countryCode: String = ""
    var timeZone: String = ""
    var lastUpdatedAt: String?

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
