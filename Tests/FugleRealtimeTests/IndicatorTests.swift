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
            var result: IndicatorGeneralResult

            result = try XCTUnwrap(Indicator.SMA(3).calculate(input: input))
            XCTAssertEqual(false, result.isEmpty)

            result = try XCTUnwrap(Indicator.EMA(3).calculate(input: input))
            XCTAssertEqual(false, result.isEmpty)

            result = try XCTUnwrap(Indicator.WMA(3).calculate(input: input))
            XCTAssertEqual(false, result.isEmpty)

            result = try XCTUnwrap(Indicator.MACD(5, 8, 3).calculate(input: input))
            XCTAssertEqual(false, result.isEmpty)
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
            var result: IndicatorGeneralResult

            result = try XCTUnwrap(Indicator.RSI(3).calculate(input: input))
            XCTAssertEqual(false, result.isEmpty)

            result = try XCTUnwrap(Indicator.StochRSI(3).calculate(input: input))
            XCTAssertEqual(false, result.isEmpty)

        } catch {
            XCTFail(error.toString())
        }
    }

    func testKD() async throws {
        client = FugleClient.initWithApiToken(apiToken)

        do {
            let responseData = try await client.getMarketData(symbol: symbolId, from: dateFrom, to: dateTo)
            let candleData = try XCTUnwrap(responseData?.candles)

            XCTAssertFalse(candleData.isEmpty)

            let result: IndicatorKDResult = try XCTUnwrap(Indicator.KD(3, 5, 8).calculate(inputs: candleData))
            XCTAssertEqual(false, result.isEmpty)

        } catch {
            XCTFail(error.toString())
        }
    }

    func testBB() async throws {
        client = FugleClient.initWithApiToken(apiToken)

        do {
            let responseData = try await client.getMarketData(symbol: symbolId, from: dateFrom, to: dateTo)
            let candleData = try XCTUnwrap(responseData?.candles)

            XCTAssertFalse(candleData.isEmpty)

            let input = candleData.map { $0.close?.doubleValue ?? 0 }

            let resultBB: IndicatorBBResult = try XCTUnwrap(Indicator.BB(5, 2).calculate(input: input))
            print(resultBB.lower)
            print(resultBB.middle)
            print(resultBB.upper)
            XCTAssertEqual(false, resultBB.isEmpty)

        } catch {
            XCTFail(error.toString())
        }
    }

    func testATR() async throws {
        client = FugleClient.initWithApiToken(apiToken)

        do {
            let responseData = try await client.getMarketData(symbol: symbolId, from: dateFrom, to: dateTo)
            let candleData = try XCTUnwrap(responseData?.candles)

            XCTAssertFalse(candleData.isEmpty)

            let result: IndicatorGeneralResult = try XCTUnwrap(Indicator.ATR(3).calculate(inputs: candleData))
            XCTAssertEqual(false, result.isEmpty)

        } catch {
            XCTFail(error.toString())
        }
    }
}
