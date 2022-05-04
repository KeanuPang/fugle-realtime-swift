//
//  Volumes.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

class ResponseVolumesData: Mappable {
    var apiVersion: String?
    var info: Info?
    var volumes = [Volumes]()

    required init?(map: Map) {}

    func mapping(map: Map) {
        apiVersion <- map["apiVersion"]
        info <- map["data.info"]
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
