//
//  Info.swift
//
//
//  Created by Keanu Pang on 2022/5/3.
//

import Foundation
import ObjectMapper

class Info: Mappable {
    var date: String = ""
    var type: String = ""
    var exchange: String = ""
    var market: String = ""
    var symbolId: String = ""
    var countryCode: String = ""
    var timeZone: String = ""
    var lastUpdatedAt: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
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
