//
//  Indicator.swift
//
//
//  Created by Keanu Pang on 2022/5/23.
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

public struct IndicatorStochResult {
    /// The stoch K values
    public let k: [Double]
    /// The stoch D values
    public let d: [Double]
}

public enum Indicator: RawRepresentable {
    /// Simple Moving Average (SMA)
    case SMA(Period_Int)
    /// Exponential Moving Average (EMA)
    case EMA(Period_Int)
    /// Weighted Moving Average (WMA)
    case WMA(Period_Int)
    /// Moving Average Convergence Divergence (MACD)
    case MACD(MACD_Short_Slow_Int, MACD_Long_Fast_Int, MACD_Signal_Int)

    /// Relative Strength Index (RSI)
    case RSI(Period_Int)
    /// Stochastic RSI (StochRSI)
    case StochRSI(Period_Int)

    /// Stochastic Oscillator (KD)
    case Stochastic(Period_K_Int, Period_K_Slow_Int, Period_D_Int)

    public init?(rawValue: String) {
        return nil
    }

    public var rawValue: String {
        switch self {
        case .SMA:
            return "sma"
        case .EMA:
            return "ema"
        case .WMA:
            return "wmv"
        case .MACD:
            return "macd"
        case .RSI:
            return "rsi"
        case .StochRSI:
            return "stochrsi"
        case .Stochastic:
            return "stoch"
        }
    }

    public func calculate(input: [Double]) -> (Int, [Double])? {
        guard !input.isEmpty else { return nil }

        var options = [Double]()
        switch self {
        case .EMA(let period),
             .RSI(let period),
             .SMA(let period),
             .StochRSI(let period),
             .WMA(let period):
            options = [Double(period)]
        case .MACD(let short, let long, let signal):
            options = [Double(short), Double(long), Double(signal)]
        case .Stochastic:
            return nil
        }

        return Tulip.call_indicator(name: self.rawValue, inputs: input, options: options)
    }

    public func calculate(candleDetails: [CandleDetails]) -> (Int, IndicatorStochResult)? {
        guard !candleDetails.isEmpty else { return nil }

        switch self {
        case .Stochastic(let kPeriod, let kSlowPeriod, let dPeriod):

            let inputs = candleDetails.map {
                return IndicatorStochInput(candleData: $0)
            }

            let result = stoch(inputs, kPeriod: kPeriod, kSlowingPeriod: kSlowPeriod, dPeriod: dPeriod)
            return (result.0, IndicatorStochResult(k: result.1.K, d: result.1.D))
        default:
            return nil
        }
    }
}

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
