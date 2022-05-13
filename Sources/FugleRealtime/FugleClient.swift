//
//  FugleClient.swift
//
//
//  Created by Keanu Pang on 2022/4/29.
//

import AsyncHTTPClient
import Foundation
import NIO
import NIOCore
import NIOFoundationCompat
import NIOHTTP1
import NIOWebSocket
import ObjectMapper
import WebSocketKit

public class FugleClient {
    public static let shared = FugleClient()

    public static func initWithApiToken(_ token: String) -> FugleClient {
        let shared = FugleClient.shared
        shared.apiToken = token
        return shared
    }

    private let logger = SharedLogger.getLogger("FugleClient")
    private let client: HTTPClient
    private var apiToken: String = ""

    private(set) var eventLoopGroup: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    private init() {
        self.client = HTTPClient(eventLoopGroupProvider: .createNew)
    }

    public func setupApiToken(_ token: String) {
        self.apiToken = token
    }

    public func shutdown() {
        try? self.client.syncShutdown()
    }

    public func shutdownWS() {
        try? self.eventLoopGroup.syncShutdownGracefully()
    }

    public func getIntraday<T: MappableData>(_ type: T.Type, resource: IntradayResource, symbol: String, oddLot: Bool = false) async throws -> T? {
        let request = buildIntradayRequest(method: .HTTP, resource: resource, symbol: symbol, oddLot: oddLot)
        let response = try await client.execute(request, timeout: DEFAULT_REQUEST_TIMEOUT)
        let body = try await response.body.collect(upTo: DEFAULT_RESPONSE_MAX_SIZE)

        dumpResponseData(body)
        guard response.status == .ok else {
            throw Mapper<CommonError>().map(JSONString: String(buffer: body)) ?? CommonError.unknownError(info: request.url)
        }

        return Mapper<T>().map(JSONString: String(buffer: body))
    }

    public func getMarketData(symbol: String, apiToken: String, from: String, to: String) async throws -> ResponseCandleData? {
        let request = buildMarketDataRequest(symbol: symbol, from: from, to: to)
        let response = try await client.execute(request, timeout: DEFAULT_REQUEST_TIMEOUT)
        let body = try await response.body.collect(upTo: DEFAULT_RESPONSE_MAX_SIZE)

        dumpResponseData(body)
        guard response.status == .ok else {
            throw Mapper<CommonError>().map(JSONString: String(buffer: body)) ?? CommonError.unknownError(info: request.url)
        }

        return Mapper<ResponseCandleData>().map(JSONString: String(buffer: body))
    }

    private func buildIntradayRequest(method: ENDPOINT_METHOD, resource: IntradayResource, symbol: String, oddLot: Bool = false) -> HTTPClientRequest {
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
        let request = HTTPClientRequest(url: "\(method.intraDayURL)/\(resource.name)?\(parameters)")
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

        let request = HTTPClientRequest(url: "\(ENDPOINT_METHOD.HTTP.marketDataURL)?\(parameters)")
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

extension FugleClient {
    public func streamIntraday<T: MappableData>(_ type: T.Type, resource: IntradayResource, symbol: String, oddLot: Bool = false, callback: ((Result<T, CommonError>) -> Void)? = nil) throws -> EventLoopPromise<T> {
        switch resource {
        case .dealts(_, _),
             .volumes:
            throw CommonError.unsupportedEroor(info: resource.name)
        default:
            break
        }

        let request = buildIntradayRequest(method: .WEB_SOCKET, resource: resource, symbol: symbol, oddLot: oddLot)

        let promise = self.eventLoopGroup.next().makePromise(of: type)
        _ = WebSocket.connect(to: request.url, on: self.eventLoopGroup) { ws in
            ws.onText { ws, json in
                guard let result = Mapper<T>().map(JSONString: json) else {
                    callback?(.failure(CommonError.jsonError(rawValue: json)))
                    return
                }
                guard let type = result.info?.type, type != "ODDLOT" else { return }

                callback?(.success(result))
            }
        }

        return promise
    }
}
