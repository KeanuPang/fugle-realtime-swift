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
        ClientConfig.setApiToken(token)
        return FugleClient.shared
    }

    private let client: HTTPClient
    private let logger: Logger = Logger.defaultLogger(category: "FugleClient")

    private(set) var eventLoopGroup: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    private init() {
        self.client = HTTPClient(eventLoopGroupProvider: .createNew)
    }

    public func shutdown() {
        try? self.client.syncShutdown()
        logger.info("shutdown client")
    }

    public func shutdownWS() {
        try? self.eventLoopGroup.next().syncShutdownGracefully()
        logger.info("shutdown websocket client")
    }

    public func getIntraday<T>(_ type: T.Type, symbol: String, oddLot: Bool = false) async throws -> T? where T: DataResource {
        logger.debug("get resource \(symbol): \(type.resource.name)")
        let request = buildIntradayRequest(method: .HTTP, resource: type.resource, symbol: symbol, oddLot: oddLot)
        let response = try await client.execute(request, timeout: ClientConfig.requestTimeout)
        let body = try await response.body.collect(upTo: ClientConfig.responseMaxSize)

        guard response.status == .ok else {
            throw Mapper<ClientError>().map(JSONString: String(buffer: body)) ?? ClientError.unexpectedError(info: request.url)
        }

        return Mapper<T>().map(JSONString: String(buffer: body))
    }

    public func getMarketData(symbol: String, from: String, to: String) async throws -> CandleData? {
        logger.debug("get market data \(symbol): \(from), \(to)")
        let request = buildMarketDataRequest(symbol: symbol, from: from, to: to)
        let response = try await client.execute(request, timeout: ClientConfig.requestTimeout)
        let body = try await response.body.collect(upTo: ClientConfig.responseMaxSize)

        guard response.status == .ok else {
            throw Mapper<ClientError>().map(JSONString: String(buffer: body)) ?? ClientError.unexpectedError(info: request.url)
        }

        return Mapper<CandleData>().map(JSONString: String(buffer: body))
    }

    private func buildIntradayRequest(method: ENDPOINT_METHOD, resource: IntradayResource, symbol: String, oddLot: Bool = false) -> HTTPClientRequest {
        var parameters = ""
        IntradayParameters.allCases.forEach {
            switch $0 {
            case .apiToken:
                parameters += "\($0.rawValue)=\(ClientConfig.getApiToken())&"
            case .symbolId:
                parameters += "\($0.rawValue)=\(symbol)&"
            case .oddLot:
                parameters += "\($0.rawValue)=\(oddLot)&"
            }
        }

        parameters += resource.pagingParameters ?? ""
        return HTTPClientRequest(url: "\(method.intraDayURL)/\(resource.name)?\(parameters)")
    }

    private func buildMarketDataRequest(symbol: String, from: String, to: String) -> HTTPClientRequest {
        var parameters = ""
        CandleParameters.allCases.forEach {
            switch $0 {
            case .apiToken:
                parameters += "\($0.rawValue)=\(ClientConfig.getApiToken())&"
            case .symbolId:
                parameters += "\($0.rawValue)=\(symbol)&"
            case .from:
                parameters += "\($0.rawValue)=\(from)&"
            case .to:
                parameters += "\($0.rawValue)=\(to)&"
            }
        }

        return HTTPClientRequest(url: "\(ENDPOINT_METHOD.HTTP.marketDataURL)?\(parameters)")
    }
}

extension FugleClient {
    public func streamIntraday<T>(_ type: T.Type, symbol: String, oddLot: Bool = false, callback: ((Result<T, ClientError>) -> Void)?) async throws -> EventLoopPromise<Void>
        where T: DataResource {
        let resource: IntradayResource = type.resource
        switch resource {
        case .dealts(_, _),
             .volumes:
            throw ClientError.unsupportedEroor(info: resource.name)
        default:
            break
        }

        logger.debug("get websocket resource \(symbol): \(resource.name)")

        let request = buildIntradayRequest(method: .WEB_SOCKET, resource: resource, symbol: symbol, oddLot: oddLot)

        let promise = self.eventLoopGroup.next().makePromise(of: Void.self)
        WebSocket.connect(to: request.url, on: self.eventLoopGroup) { [weak self] ws in
            ws.onText { ws, json in
                self?.logger.debug("websocket response: \(json)")

                guard let result = Mapper<T>().map(JSONString: json) else {
                    callback?(.failure(ClientError.jsonError(rawValue: json)))
                    return
                }
                guard let type = result.info?.type, type != "ODDLOT" else { return }

                callback?(.success(result))
            }
            ws.onClose.cascade(to: promise)
        }.flatMapError { [weak self] in
            self?.logger.error($0.toString())

            if $0 is WebSocketClient.Error {
                callback?(.failure(ClientErrorCode.invalidTokenOrUrl.toError($0.toString())))
            } else {
                callback?(.failure(ClientErrorCode.unexpectedError.toError($0.toString())))
            }

            return promise.futureResult
        }.cascadeFailure(to: promise)

        return promise
    }
}
