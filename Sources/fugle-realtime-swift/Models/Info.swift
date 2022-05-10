//
//  Info.swift
//
//
//  Created by Keanu Pang on 2022/5/3.
//

import Foundation
import ObjectMapper

protocol MappableData: Mappable {
    var apiVersion: String? { get set }
    var info: Info? { get set }
}

class MappableDataClass: MappableData {
    var apiVersion: String?
    var info: Info?

    required init?(map: Map) {}

    func mapping(map: Map) {
        apiVersion <- map["apiVersion"]
        info <- map["data.info"]
    }
}

class Info: MappableDataClass {
    var date: String = ""
    var type: String = ""
    var exchange: String = ""
    var market: String = ""
    var symbolId: String = ""
    var countryCode: String = ""
    var timeZone: String = ""
    var lastUpdatedAt: String?

    override func mapping(map: Map) {
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
