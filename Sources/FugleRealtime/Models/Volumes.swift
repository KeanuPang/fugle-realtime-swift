//
//  Volumes.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

public class VolumesData: MappableDataClass, ResourceType {
    public var volumes = [Volumes]()

    public static var resource: IntradayResource {
        return .volumes
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)

        volumes <- map["data.volumes"]
    }
}

public class Volumes: Mappable {
    public var price: NSDecimalNumber?
    public var volume: UInt64?

    public required init?(map: Map) {}

    public func mapping(map: Map) {
        price <- (map["price"], NSDecimalNumberTransform())
        volume <- map["volume"]
    }
}
