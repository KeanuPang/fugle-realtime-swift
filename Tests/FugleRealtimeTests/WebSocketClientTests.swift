//
//  WebSocketClientTests.swift
//
//
//  Created by Keanu Pang on 2022/5/10.
//

@testable import FugleRealtime
import NIO
import XCTest

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

    func testUnauthorizedRequest() async throws {
        client = FugleClient.initWithApiToken("")

        do {
            var promise: EventLoopPromise<Void>?
            promise = try await client.streamIntraday(ResponseMetaData.self, resource: .meta, symbol: symbolId, callback: nil)

            try promise?.futureResult.wait()
            XCTFail()
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testInvalidToken() async throws {
        client = FugleClient.initWithApiToken("abcdefghijklmn")

        do {
            var promise: EventLoopPromise<Void>?
            promise = try await client.streamIntraday(ResponseMetaData.self, resource: .meta, symbol: symbolId, callback: nil)

            try promise?.futureResult.wait()
            XCTFail()
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testMetaRequestWS() async throws {
        var response: ResponseMetaData?
        var promise: EventLoopPromise<Void>?
        promise = try await client.streamIntraday(ResponseMetaData.self, resource: .meta, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                response = result
                promise?.succeed(())
            case .failure(let failures):
                XCTFail(failures.toString())
            }
        })

        try promise?.futureResult.wait()

        let info = (try XCTUnwrap(response?.info))
        let priceReference = (try XCTUnwrap(response?.meta?.priceReference))

        XCTAssertEqual(self.symbolId, info.symbolId)
        XCTAssertTrue(priceReference.decimalValue > 0)
    }

    func testQuoteRequestWS() async throws {
        var response: ResponseQuoteData?
        var promise: EventLoopPromise<Void>?
        promise = try await client.streamIntraday(ResponseQuoteData.self, resource: .quote, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                response = result
                promise?.succeed(())
            case .failure(let failures):
                XCTFail(failures.toString())
            }
        })

        try promise?.futureResult.wait()

        let info = (try XCTUnwrap(response?.info))
        let quoteChange = (try XCTUnwrap(response?.quote?.change))

        XCTAssertEqual(self.symbolId, info.symbolId)
        XCTAssertTrue(quoteChange.decimalValue.isNormal)
    }

    func testChartRequestWS() async throws {
        var response: ResponseChartData?
        var promise: EventLoopPromise<Void>?
        promise = try await client.streamIntraday(ResponseChartData.self, resource: .chart, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                response = result
                promise?.succeed(())
            case .failure(let failures):
                XCTFail(failures.toString())
            }
        })

        try promise?.futureResult.wait()

        let info = (try XCTUnwrap(response?.info))
        let volume = (try XCTUnwrap(response?.chart?.v))

        XCTAssertEqual(self.symbolId, info.symbolId)
        XCTAssertTrue(volume.count > 0)
    }

    func testDealtsRequestWS() async {
        do {
            _ = try await client.streamIntraday(ResponseDealtsData.self, resource: .dealts(), symbol: symbolId, callback: nil)
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
