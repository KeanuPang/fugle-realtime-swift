//
//  FugleClient.swift
//
//
//  Created by Keanu Pang on 2022/4/29.
//

import AsyncHTTPClient
import Foundation
import NIOCore
import NIOFoundationCompat
import ObjectMapper

public class FugleClient {
    static let shared = FugleClient()

    static func initWithApiToken(_ token: String) -> FugleClient {
        let shared = FugleClient.shared
        shared.apiToken = token
        return shared
    }

    private let logger = SharedLogger.getLogger("FugleClient")
    private let client: HTTPClient
    private var apiToken: String = ""

    private init() {
        self.client = HTTPClient(eventLoopGroupProvider: .createNew)
    }

    func setupApiToken(_ token: String) {
        self.apiToken = token
    }

    func getIntraday<T: Mappable>(_ type: T.Type, resource: IntradayResource, symbol: String) async throws -> T? {
        let request = buildIntradayRequest(resource: resource, symbol: symbol)
        let response = try await client.execute(request, timeout: DEFAULT_REQUEST_TIMEOUT)
        let body = try await response.body.collect(upTo: DEFAULT_RESPONSE_MAX_SIZE)

        dumpResponseData(body)
        guard response.status == .ok else {
            throw Mapper<CommonError>().map(JSONString: String(buffer: body)) ?? CommonError.unknownError(info: request.url)
        }

        return Mapper<T>().map(JSONString: String(buffer: body))
    }

    func getMarketData(symbol: String, apiToken: String, from: String, to: String) async throws -> ResponseCandleData? {
        let request = buildMarketDataRequest(symbol: symbol, from: from, to: to)
        let response = try await client.execute(request, timeout: DEFAULT_REQUEST_TIMEOUT)
        let body = try await response.body.collect(upTo: DEFAULT_RESPONSE_MAX_SIZE)

        dumpResponseData(body)
        guard response.status == .ok else {
            throw Mapper<CommonError>().map(JSONString: String(buffer: body)) ?? CommonError.unknownError(info: request.url)
        }

        return Mapper<ResponseCandleData>().map(JSONString: String(buffer: body))
    }

    private func buildIntradayRequest(resource: IntradayResource, symbol: String, oddLot: Bool = false) -> HTTPClientRequest {
        var parameters = ""
        IntradayParameters.allCases.forEach {
            switch $0 {
            case .apiToken:
                parameters += "\($0.rawValue)=\(self.apiToken)&"
            case .symbolId:
                parameters += "\($0.rawValue)=\(symbol)&"
            case .oddLot:
                parameters += "\($0.rawValue)=\(oddLot)&"
            }
        }

        parameters += resource.pagingParameters ?? ""
        let request = HTTPClientRequest(url: "\(FUGLE_ENDPOINT_INTRADAY)/\(resource.name)?\(parameters)")
        dumpRequest(request)
        return request
    }

    private func buildMarketDataRequest(symbol: String, from: String, to: String) -> HTTPClientRequest {
        var parameters = ""
        CandleParameters.allCases.forEach {
            switch $0 {
            case .apiToken:
                parameters += "\($0.rawValue)=\(apiToken)&"
            case .symbolId:
                parameters += "\($0.rawValue)=\(symbol)&"
            case .from:
                parameters += "\($0.rawValue)=\(from)&"
            case .to:
                parameters += "\($0.rawValue)=\(to)&"
            }
        }

        let request = HTTPClientRequest(url: "\(FUGLE_ENDPOINT_MARKETDATA)?\(parameters)")
        dumpRequest(request)
        return request
    }

    private func dumpRequest(_ request: HTTPClientRequest) {
        guard logger.logLevel == .debug else { return }
        logger.debug("\(request.url)")
    }

    private func dumpResponseData(_ body: ByteBuffer) {
        guard logger.logLevel == .debug else { return }
        logger.debug("\(String(buffer: body))")
    }
}
