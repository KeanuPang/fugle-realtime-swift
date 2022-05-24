//
//  Indicator.swift
//
//
//  Created by Keanu Pang on 2022/5/23.
//

import Foundation
import tulipindicators

typealias MACD_Short = Int
typealias MACD_Long = Int
typealias MACD_Signal = Int

enum Indicator: RawRepresentable {
    init?(rawValue: String) {
        return nil
    }

    /// Simple Moving Average (SMA)
    case SMA
    /// Exponential Moving Average (EMA)
    case EMA
    /// Weighted Moving Average (WMA)
    case WMA
    /// Moving Average Convergence Divergence (MACD), options: short, long, signal
    case MACD(MACD_Short, MACD_Long, MACD_Signal)

    /// Relative Strength Index (RSI)
    case RSI
    /// Stochastic RSI (StochRSI)
    case StochRSI

    var rawValue: String {
        switch self {
        case .SMA:
            return "SMA"
        case .EMA:
            return "EMA"
        case .WMA:
            return "WMA"
        case .MACD:
            return "MACD"
        case .RSI:
            return "RSI"
        case .StochRSI:
            return "StochRSI"
        }
    }

    private var tulipName: String {
        return self.rawValue.lowercased()
    }

    func calculate(input: [Double], options: Double ...) -> (Int, [Double])? {
        guard !input.isEmpty else { return nil }

        switch self {
        case .MACD(let short, let long, let signal):
            return Tulip.call_indicator(name: self.tulipName, inputs: input,
                                        options: [Double(short), Double(long), Double(signal)])
        default:
            return Tulip.call_indicator(name: self.tulipName, inputs: input, options: options)
        }
    }
}
