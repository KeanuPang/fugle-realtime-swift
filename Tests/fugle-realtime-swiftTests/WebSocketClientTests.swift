//
//  WebSocketClientTests.swift
//
//
//  Created by Keanu Pang on 2022/5/10.
//

@testable import fugle_realtime_swift
import XCTest

@available(macOS 12, *)
final class WebSocketClientTests: XCTestCase {
    private let apiToken: String = "demo"
    private let symbolId: String = "2884"

    private lazy var client: FugleClient = FugleClient.initWithApiToken(apiToken)

    override func setUp() {
        client = FugleClient.initWithApiToken(apiToken)
    }

    override class func tearDown() {
        FugleClient.shared.shutdownWS()
    }

    func testMetaRequestWS() throws {
        var response: ResponseMetaData?

        let expectedResult = expectation(description: "waiting")
        try client.streamIntraday(ResponseMetaData.self, resource: .meta, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                response = result
                expectedResult.fulfill()
            case .failure(let failures):
                XCTFail(failures.toString())
            }
        })

        waitForExpectations(timeout: 1, handler: { _ in
            do {
                let info = (try XCTUnwrap(response?.info))
                let priceReference = (try XCTUnwrap(response?.meta?.priceReference))

                XCTAssertEqual(self.symbolId, info.symbolId)
                XCTAssertTrue(priceReference.decimalValue > 0)
            } catch {
                XCTFail(error.toString())
            }
        })
    }

    func testQuoteRequestWS() throws {
        var response: ResponseQuoteData?

        let expectedResult = expectation(description: "waiting")
        try client.streamIntraday(ResponseQuoteData.self, resource: .quote, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                response = result
                expectedResult.fulfill()
            case .failure(let failures):
                XCTFail(failures.toString())
            }
        })

        waitForExpectations(timeout: 1, handler: { _ in
            do {
                let info = (try XCTUnwrap(response?.info))
                let quoteChange = (try XCTUnwrap(response?.quote?.change))

                XCTAssertEqual(self.symbolId, info.symbolId)
                XCTAssertTrue(quoteChange.decimalValue > 0)
            } catch {
                XCTFail(error.toString())
            }
        })
    }

    func testChartRequestWS() throws {
        var response: ResponseChartData?

        let expectedResult = expectation(description: "waiting")
        try client.streamIntraday(ResponseChartData.self, resource: .chart, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                response = result
                expectedResult.fulfill()
            case .failure(let failures):
                XCTFail(failures.toString())
            }
        })

        waitForExpectations(timeout: 1, handler: { _ in
            do {
                let info = (try XCTUnwrap(response?.info))
                let volume = (try XCTUnwrap(response?.chart?.v))

                XCTAssertEqual(self.symbolId, info.symbolId)
                XCTAssertTrue(volume.count > 0)
            } catch {
                XCTFail(error.toString())
            }
        })
    }

    func testDealtsRequestWS() throws {
        XCTAssertThrowsError(
            try client.streamIntraday(ResponseDealtsData.self, resource: .dealts(), symbol: symbolId)
        )
    }
}
