@testable import fugle_realtime_swift
import XCTest

final class fugle_realtime_swiftTests: XCTestCase {
    private let apiToken: String = "demo"
    private let symbolId: String = "2884"

    override func setUp() {
        _ = FugleClient.initWithApiToken(apiToken)
    }

    func testMetaRequest() async throws {
        do {
            let response: ResponseMetaData? = try await FugleClient.shared.getIntraday(ResponseMetaData.self, resource: .meta, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testQuoteRequest() async throws {
        do {
            let response: ResponseQuoteData? = try await FugleClient.shared.getIntraday(ResponseQuoteData.self, resource: .quote, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testChartRequest() async throws {
        do {
            let response: ResponseChartData? = try await FugleClient.shared.getIntraday(ResponseChartData.self, resource: .chart, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testDealtsRequest() async throws {
        do {
            let response: ResponseDealtsData? = try await FugleClient.shared.getIntraday(ResponseDealtsData.self, resource: .dealts(50, 0), symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testVolumesRequest() async throws {
        do {
            let response: ResponseVolumesData? = try await FugleClient.shared.getIntraday(ResponseVolumesData.self, resource: .volumes, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testMarketRequest() async throws {
        do {
            let response: ResponseCandleData? = try await FugleClient.shared.getMarketData(symbol: symbolId,
                                                                                           apiToken: apiToken,
                                                                                           from: "2022-04-25",
                                                                                           to: "2022-04-29")

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }
}
