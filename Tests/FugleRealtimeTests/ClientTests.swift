@testable import FugleRealtime
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

    func testUnauthorizedRequest() async throws {
        client = FugleClient.initWithApiToken("")

        do {
            _ = try await client.getIntraday(MetaData.self, symbol: symbolId)
            XCTFail("API Should not be called due to invalid token")
        } catch {
            XCTAssertTrue(error is ClientError)
            XCTAssertEqual("401", try XCTUnwrap((error as? ClientError)?.error?.code))
        }
    }

    func testInvalidToken() async throws {
        client = FugleClient.initWithApiToken("abcdefghijklmn")

        do {
            _ = try await client.getIntraday(MetaData.self, symbol: symbolId)
            XCTFail("API Should not be called due to invalid token")
        } catch {
            XCTAssertTrue(error is ClientError)
            XCTAssertEqual("400", try XCTUnwrap((error as? ClientError)?.error?.code))
        }
    }

    func testMetaRequest() async throws {
        do {
            let response: MetaData? = try await client.getIntraday(MetaData.self, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testQuoteRequest() async throws {
        do {
            let response: QuoteData? = try await client.getIntraday(QuoteData.self, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testChartRequest() async throws {
        do {
            let response: ChartData? = try await client.getIntraday(ChartData.self, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testDealtsRequest() async throws {
        do {
            let response: DealtsData? = try await client.getIntraday(DealtsData.self, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testVolumesRequest() async throws {
        do {
            let response: VolumesData? = try await client.getIntraday(VolumesData.self, symbol: symbolId)

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.info?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }

    func testMarketRequest() async throws {
        do {
            let response: CandleData? = try await client.getMarketData(symbol: symbolId,
                                                                       from: "2022-04-25",
                                                                       to: "2022-04-29")

            XCTAssertEqual(symbolId, try XCTUnwrap(response?.symbolId))
        } catch {
            XCTFail(error.toString())
        }
    }
}
