//
//  Chart.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

class ResponseChartData: Mappable {
    var apiVersion: String?
    var info: Info?
    var chart: Chart?

    required init?(map: Map) {}

    func mapping(map: Map) {
        apiVersion <- map["apiVersion"]
        info <- map["data.info"]
        chart <- map["data.chart"]
    }
}

class Chart: Mappable {
    var a = [NSDecimalNumber]()
    var o = [NSDecimalNumber]()
    var h = [NSDecimalNumber]()
    var l = [NSDecimalNumber]()
    var c = [NSDecimalNumber]()
    var v = [UInt64]()
    var t = [UInt64]()

    required init?(map: Map) {}

    func mapping(map: Map) {
        a <- (map["a"], NSDecimalNumberTransform())
        o <- (map["o"], NSDecimalNumberTransform())
        h <- (map["h"], NSDecimalNumberTransform())
        l <- (map["l"], NSDecimalNumberTransform())
        c <- (map["c"], NSDecimalNumberTransform())
        v <- map["v"]
        t <- map["t"]
    }
}
