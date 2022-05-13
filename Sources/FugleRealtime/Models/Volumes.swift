//
//  Volumes.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

public class ResponseVolumesData: MappableDataClass {
    var volumes = [Volumes]()

    override public func mapping(map: Map) {
        super.mapping(map: map)

        volumes <- map["data.volumes"]
    }
}

public class Volumes: Mappable {
    var price: NSDecimalNumber?
    var volume: UInt64?

    public required init?(map: Map) {}

    public func mapping(map: Map) {
        price <- (map["price"], NSDecimalNumberTransform())
        volume <- map["volume"]
    }
}