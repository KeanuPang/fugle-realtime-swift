//
//  Chart.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

public class ResponseChartData: MappableDataClass {
    var chart: Chart?

    override public func mapping(map: Map) {
        super.mapping(map: map)

        chart <- map["data.chart"]
    }
}

public class Chart: Mappable {
    var a = [NSDecimalNumber]()
    var o = [NSDecimalNumber]()
    var h = [NSDecimalNumber]()
    var l = [NSDecimalNumber]()
    var c = [NSDecimalNumber]()
    var v = [UInt64]()
    var t = [UInt64]()

    public required init?(map: Map) {}

    public func mapping(map: Map) {
        a <- (map["a"], NSDecimalNumberTransform())
        o <- (map["o"], NSDecimalNumberTransform())
        h <- (map["h"], NSDecimalNumberTransform())
        l <- (map["l"], NSDecimalNumberTransform())
        c <- (map["c"], NSDecimalNumberTransform())
        v <- map["v"]
        t <- map["t"]
    }
}
