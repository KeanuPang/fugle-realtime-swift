@testable import fugle_realtime_swift
import XCTest

final class ClientTests: XCTestCase {
    private let apiToken: String = "demo"
    private let symbolId: String = "2884"

    private lazy var client: FugleClient = FugleClient.initWithApiToken(apiToken)

    override func setUp() {
        client = FugleClient.initWithApiToken(apiToken)
    }

    override class func tearDown() {
        FugleClient.shared.shutdown()
    }

    func testMetaRequest() async throws {
        do {
            let response: ResponseMetaData? = try await client.getIntraday(ResponseMetaData.self, resource: .meta, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testQuoteRequest() async throws {
        do {
            let response: ResponseQuoteData? = try await client.getIntraday(ResponseQuoteData.self, resource: .quote, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testChartRequest() async throws {
        do {
            let response: ResponseChartData? = try await client.getIntraday(ResponseChartData.self, resource: .chart, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testDealtsRequest() async throws {
        do {
            let response: ResponseDealtsData? = try await client.getIntraday(ResponseDealtsData.self, resource: .dealts(), symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testVolumesRequest() async throws {
        do {
            let response: ResponseVolumesData? = try await client.getIntraday(ResponseVolumesData.self, resource: .volumes, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testMarketRequest() async throws {
        do {
            let response: ResponseCandleData? = try await client.getMarketData(symbol: symbolId,
                                                                               apiToken: apiToken,
                                                                               from: "2022-04-25",
                                                                               to: "2022-04-29")

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }
}
