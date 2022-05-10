//
//  Volumes.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

class ResponseVolumesData: MappableDataClass {
    var volumes = [Volumes]()

    override func mapping(map: Map) {
        super.mapping(map: map)

        volumes <- map["data.volumes"]
    }
}

class Volumes: Mappable {
    var price: NSDecimalNumber?
    var volume: UInt64?

    required init?(map: Map) {}

    func mapping(map: Map) {
        price <- (map["price"], NSDecimalNumberTransform())
        volume <- map["volume"]
    }
}
