//
//  WebSocketClientTests.swift
//
//
//  Created by Keanu Pang on 2022/5/10.
//

@testable import fugle_realtime_swift
import XCTest

class WebSocketClientTests: XCTestCase {
    private let apiToken: String = "demo"
    private let symbolId: String = "2884"

    private lazy var client: FugleClient = FugleClient.initWithApiToken(apiToken)

    override func tearDownWithError() throws {
        try client.shutdown()
    }

    @available(macOS 12, *)
    func testMetaRequestWS() async throws {
        do {
            let result = try await client.connectIntraday(ResponseMetaData.self, resource: .meta, symbol: symbolId)

            let price = (try XCTUnwrap(result?.meta?.priceReference))
            XCTAssertTrue(price.decimalValue > 0)

        } catch {
            XCTFail(error.toString())
        }
    }
}
