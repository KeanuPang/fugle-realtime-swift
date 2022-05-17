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
        var errorResponse: ClientError?
        client = FugleClient.initWithApiToken("")

        var promise: EventLoopPromise<Void>?
        promise = try await client.streamIntraday(MetaData.self, symbol: symbolId, callback: {
            switch $0 {
            case .success:
                XCTFail()
            case .failure(let failures):
                errorResponse = failures
            }
            promise?.succeed(())
        })

        try promise?.futureResult.wait()

        XCTAssertNotNil(errorResponse)
        XCTAssertEqual(ClientErrorCode.invalidTokenOrUrl.rawValue, try XCTUnwrap(errorResponse?.error?.code))
    }

    func testInvalidToken() async throws {
        var errorResponse: ClientError?
        client = FugleClient.initWithApiToken("abcdefghijklmn")

        var promise: EventLoopPromise<Void>?
        promise = try await client.streamIntraday(MetaData.self, symbol: symbolId, callback: {
            switch $0 {
            case .success:
                XCTFail()
            case .failure(let failures):
                errorResponse = failures
            }
            promise?.succeed(())
        })

        try promise?.futureResult.wait()
        XCTAssertNotNil(errorResponse)
    }

    func testMetaRequestWS() async throws {
        var response: MetaData?
        var promise: EventLoopPromise<Void>?
        promise = try await client.streamIntraday(MetaData.self, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                response = result
            case .failure(let failures):
                XCTFail(failures.toString())
            }
            promise?.succeed(())
        })

        try promise?.futureResult.wait()

        let info = (try XCTUnwrap(response?.info))
        let priceReference = (try XCTUnwrap(response?.meta?.priceReference))

        XCTAssertEqual(self.symbolId, info.symbolId)
        XCTAssertTrue(priceReference.decimalValue > 0)
    }

    func testQuoteRequestWS() async throws {
        var response: QuoteData?
        var promise: EventLoopPromise<Void>?
        promise = try await client.streamIntraday(QuoteData.self, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                response = result
            case .failure(let failures):
                XCTFail(failures.toString())
            }
            promise?.succeed(())
        })

        try promise?.futureResult.wait()

        let info = (try XCTUnwrap(response?.info))
        let quoteChange = (try XCTUnwrap(response?.quote?.change))

        XCTAssertEqual(self.symbolId, info.symbolId)
        XCTAssertTrue(quoteChange.decimalValue.isNormal)
    }

    func testChartRequestWS() async throws {
        var response: ChartData?
        var promise: EventLoopPromise<Void>?
        promise = try await client.streamIntraday(ChartData.self, symbol: symbolId, callback: {
            switch $0 {
            case .success(let result):
                response = result
            case .failure(let failures):
                XCTFail(failures.toString())
            }
            promise?.succeed(())
        })

        try promise?.futureResult.wait()

        let info = (try XCTUnwrap(response?.info))
        let volume = (try XCTUnwrap(response?.chart?.v))

        XCTAssertEqual(self.symbolId, info.symbolId)
        XCTAssertTrue(volume.count > 0)
    }

    func testDealtsRequestWS() async {
        do {
            _ = try await client.streamIntraday(DealtsData.self, symbol: symbolId, callback: nil)
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
