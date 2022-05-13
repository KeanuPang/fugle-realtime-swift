//
//  WebSocketClientTests.swift
//
//
//  Created by Keanu Pang on 2022/5/10.
//

@testable import FugleRealtime
import NIO
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
        var promise: EventLoopPromise<ResponseMetaData>?

        promise = try client.streamIntraday(ResponseMetaData.self, resource: .meta, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                promise?.succeed(result)
            case .failure(let failures):
                XCTFail(failures.toString())
            }
        })

        let response = try promise?.futureResult.wait()

        let info = (try XCTUnwrap(response?.info))
        let priceReference = (try XCTUnwrap(response?.meta?.priceReference))

        XCTAssertEqual(self.symbolId, info.symbolId)
        XCTAssertTrue(priceReference.decimalValue > 0)
    }

    func testQuoteRequestWS() throws {
        var promise: EventLoopPromise<ResponseQuoteData>?

        promise = try client.streamIntraday(ResponseQuoteData.self, resource: .quote, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                promise?.succeed(result)
            case .failure(let failures):
                XCTFail(failures.toString())
            }
        })

        let response = try promise?.futureResult.wait()

        let info = (try XCTUnwrap(response?.info))
        let quoteChange = (try XCTUnwrap(response?.quote?.change))

        XCTAssertEqual(self.symbolId, info.symbolId)
        XCTAssertTrue(quoteChange.decimalValue.isNormal)
    }

    func testChartRequestWS() throws {
        var promise: EventLoopPromise<ResponseChartData>?

        promise = try client.streamIntraday(ResponseChartData.self, resource: .chart, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                promise?.succeed(result)
            case .failure(let failures):
                XCTFail(failures.toString())
            }
        })

        let response = try promise?.futureResult.wait()

        let info = (try XCTUnwrap(response?.info))
        let volume = (try XCTUnwrap(response?.chart?.v))

        XCTAssertEqual(self.symbolId, info.symbolId)
        XCTAssertTrue(volume.count > 0)
    }

    func testDealtsRequestWS() throws {
        XCTAssertThrowsError(
            try client.streamIntraday(ResponseDealtsData.self, resource: .dealts(), symbol: symbolId)
        )
    }
}