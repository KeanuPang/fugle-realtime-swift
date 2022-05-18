//
//  Chart.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation
import ObjectMapper

/// Chart data class for Fugle intraday endpoint
public class ChartData: DataResource {
    public var chart: Chart?

    public static var resource: IntradayResource {
        return .chart
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)

        chart <- map["data.chart"]
    }
}

public class Chart: Mappable {
    public var a = [NSDecimalNumber]()
    public var o = [NSDecimalNumber]()
    public var h = [NSDecimalNumber]()
    public var l = [NSDecimalNumber]()
    public var c = [NSDecimalNumber]()
    public var v = [UInt64]()
    public var t = [UInt64]()

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
