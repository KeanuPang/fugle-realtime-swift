//
//  Indicator_Input+Output.swift
//
//
//  Created by Keanu Pang on 2022/5/25.
//

import Foundation
import tulipindicators

/// Parameter types for Indicator
public typealias Period_Int = Int
public typealias MACD_Short_Slow_Int = Int
public typealias MACD_Long_Fast_Int = Int
public typealias MACD_Signal_Int = Int
public typealias Period_K_Int = Int
public typealias Period_K_Slow_Int = Int
public typealias Period_D_Int = Int
public typealias StdDev_Double = Double

struct IndicatorStochInput: Quotable {
    var high: Double
    var low: Double
    var open: Double
    var close: Double
    var volume: Int

    init(candleData: CandleDetails) {
        self.high = candleData.high?.doubleValue ?? 0
        self.low = candleData.low?.doubleValue ?? 0
        self.open = candleData.open?.doubleValue ?? 0
        self.close = candleData.close?.doubleValue ?? 0
        self.volume = Int(candleData.volume ?? UInt64(0))
    }
}

public protocol IndicatorResult {
    var isEmpty: Bool { get }
}

public struct IndicatorGenericResult: IndicatorResult {
    public let result: [Double]

    public var isEmpty: Bool {
        self.result.isEmpty
    }
}

public struct IndicatorStochResult: IndicatorResult {
    /// The stoch K values
    public let k: [Double]
    /// The stoch D values
    public let d: [Double]

    public var isEmpty: Bool {
        self.k.isEmpty || self.d.isEmpty
    }
}

public struct IndicatorBBResult: IndicatorResult {
    /// The lower values
    public let lower: [Double]
    /// The middle values
    public let middle: [Double]
    /// The upper values
    public let upper: [Double]

    public var isEmpty: Bool {
        self.lower.isEmpty || self.middle.isEmpty || self.upper.isEmpty
    }
}
