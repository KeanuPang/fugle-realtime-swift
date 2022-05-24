//
//  IndicatorTests.swift
//
//
//  Created by Keanu Pang on 2022/5/24.
//

@testable import FugleRealtime
import tulipindicators
import XCTest

final class IndicatorTests: XCTestCase {
    private let apiToken: String = "demo"
    private let symbolId: String = "2884"
    private let dateFrom: String = "2022-04-01"
    private let dateTo: String = "2022-04-30"

    private lazy var client: FugleClient = FugleClient.initWithApiToken(apiToken)

    override func setUp() {
        client = FugleClient.initWithApiToken(apiToken)
    }

    override class func tearDown() {
        FugleClient.shared.shutdown()
    }

    func testMA() async throws {
        client = FugleClient.initWithApiToken(apiToken)

        do {
            let responseData = try await client.getMarketData(symbol: symbolId, from: dateFrom, to: dateTo)
            let candleData = try XCTUnwrap(responseData?.candles)

            XCTAssertFalse(candleData.isEmpty)

            let input = candleData.map { $0.close?.doubleValue ?? 0 }

            let resultSMA = try XCTUnwrap(Indicator.SMA.calculate(input: input, options: 3))
            XCTAssertEqual(false, resultSMA.1.isEmpty)

            let resultEMA = try XCTUnwrap(Indicator.EMA.calculate(input: input, options: 3))
            XCTAssertEqual(false, resultEMA.1.isEmpty)

            let resultWMA = try XCTUnwrap(Indicator.WMA.calculate(input: input, options: 3))
            XCTAssertEqual(false, resultWMA.1.isEmpty)

            let resultMACD = try XCTUnwrap(Indicator.MACD(5, 8, 3).calculate(input: input))
            XCTAssertEqual(false, resultMACD.1.isEmpty)
        } catch {
            XCTFail(error.toString())
        }
    }

    func testRSI() async throws {
        client = FugleClient.initWithApiToken(apiToken)

        do {
            let responseData = try await client.getMarketData(symbol: symbolId, from: dateFrom, to: dateTo)
            let candleData = try XCTUnwrap(responseData?.candles)

            XCTAssertFalse(candleData.isEmpty)

            let input = candleData.map { $0.close?.doubleValue ?? 0 }

            let resultRSI = try XCTUnwrap(Indicator.RSI.calculate(input: input, options: 3))
            XCTAssertEqual(false, resultRSI.1.isEmpty)

            let resultStochRSI = try XCTUnwrap(Indicator.StochRSI.calculate(input: input, options: 3))
            XCTAssertEqual(false, resultStochRSI.1.isEmpty)

        } catch {
            XCTFail(error.toString())
        }
    }
}
