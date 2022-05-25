//
//  Indicator.swift
//
//
//  Created by Keanu Pang on 2022/5/23.
//

import Foundation
import tulipindicators

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
    case KD(Period_K_Int, Period_K_Slow_Int, Period_D_Int)

    /// Bollinger Bands (BB)
    case BB(Period_Int, StdDev_Double)

    /// Average True Range (ATR)
    case ATR(Period_Int)

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
            return "wma"
        case .MACD:
            return "macd"
        case .RSI:
            return "rsi"
        case .StochRSI:
            return "stochrsi"
        case .KD:
            return "stoch"
        case .BB:
            return "bbands"
        case .ATR:
            return "atr"
        }
    }

    public func calculate<T: IndicatorResult>(input: [Double] = [Double](), inputs: [CandleDetails] = [CandleDetails]()) -> T? {
        if input.isEmpty, inputs.isEmpty { return nil }

        var options = [Double]()
        switch self {
        case
            .EMA(let period),
            .RSI(let period),
            .SMA(let period),
            .StochRSI(let period),
            .WMA(let period):
            options = [Double(period)]

        case .MACD(let short, let long, let signal):
            options = [Double(short), Double(long), Double(signal)]

        case .BB(let period, let stdDev):
            let result = bbands(input, period: period, stddev: stdDev)
            return IndicatorBBResult(lower: result.1.lower, middle: result.1.middle, upper: result.1.upper) as? T

        case .KD(let kPeriod, let kSlowPeriod, let dPeriod):
            let mInputs = inputs.map { IndicatorInputs(candleData: $0) }
            let result = stoch(mInputs, kPeriod: kPeriod, kSlowingPeriod: kSlowPeriod, dPeriod: dPeriod)
            return IndicatorKDResult(k: result.1.K, d: result.1.D) as? T

        case .ATR(let period):
            let mInputs = inputs.map { IndicatorInputs(candleData: $0) }
            let result = atr(mInputs, period: period)
            return IndicatorGeneralResult(result: result.1) as? T
        }

        let result = Tulip.call_indicator(name: self.rawValue, inputs: input, options: options)
        return IndicatorGeneralResult(result: result.1) as? T
    }
}
