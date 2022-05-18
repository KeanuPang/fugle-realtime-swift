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

/// The main HTTP and WebSocket client for Fulge Intraday/Marketdata endpoints.
public class FugleClient {
    /// Build and return the client single instance.
    public static let shared = FugleClient()

    /**
     Pass the API token as parameter to build and return client instance.

     - parameter token: The Fugle api token.
     - returns: The created client instance.
     */
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

    /// Shutdown the HTTP client.
    public func shutdown() {
        try? self.client.syncShutdown()
        logger.info("shutdown client")
    }

    /// Shutdown the WebSocket client gracefully.
    public func shutdownWS() {
        try? self.eventLoopGroup.next().syncShutdownGracefully()
        logger.info("shutdown websocket client")
    }

    /**
     Get the Dealts result data in day from Intraday endpoint.

     - parameter symbol:        The symbol id to get dealts data.
     - parameter oddLot:        Only get the odd lot data, default is false.
     - parameter pagingLimit:   Returns data size by this time, defaults to `50`.
     - parameter pagingOffset:  Specify the page number which is zero-based index, defaults to `0`.
     - returns:                 The `DealtsData` model result by the specified symbol.
     - note:                    Before calling the Fugle API, your should specify API token first for this client.
     */
    public func getIntradayDealts(symbol: String, oddLot: Bool = false, pagingLimit: PAGING_LIMIT? = nil,
                                  pagingOffset: PAGING_OFFSET? = nil) async throws -> DealtsData? {
        let dealts = IntradayResource.dealts(pagingLimit ?? ClientConfig.pageLimitDealts, pagingOffset ?? 0)
        logger.debug("get dealts resource \(symbol): \(dealts.name)")
        let request = buildIntradayRequest(method: .HTTP, resource: dealts, symbol: symbol, oddLot: oddLot)
        let response = try await client.execute(request, timeout: ClientConfig.requestTimeout)
        let body = try await response.body.collect(upTo: ClientConfig.responseMaxSize)

        guard response.status == .ok else {
            throw Mapper<ClientError>().map(JSONString: String(buffer: body)) ?? ClientError.unexpectedError(info: request.url)
        }

        return Mapper<DealtsData>().map(JSONString: String(buffer: body))
    }

    /**
     Get the intraday result data in day from Intraday endpoint.

     - parameter type:      Data type implementation for this query, please refer to `MappableDataClass`.
     - parameter symbol:    The symbol id to get data by type.
     - parameter oddLot:    Only get the odd lot data, default is false.
     - returns:             The model data by the specified symbol.
     - note:                Before calling the Fugle API, your should specify API token first for this client.
     */
    public func getIntraday<T>(_ type: T.Type, symbol: String, oddLot: Bool = false) async throws -> T? where T: MappableDataClass {
        guard let resource = (type as? ResourceType.Type)?.resource else { return nil }

        logger.debug("get resource \(symbol): \(resource.name)")
        let request = buildIntradayRequest(method: .HTTP, resource: resource, symbol: symbol, oddLot: oddLot)
        let response = try await client.execute(request, timeout: ClientConfig.requestTimeout)
        let body = try await response.body.collect(upTo: ClientConfig.responseMaxSize)

        guard response.status == .ok else {
            throw Mapper<ClientError>().map(JSONString: String(buffer: body)) ?? ClientError.unexpectedError(info: request.url)
        }

        return Mapper<T>().map(JSONString: String(buffer: body))
    }

    /**
     Get the historical data by symbol from Marketdata endpoint.

     - parameter symbol:    The symbol id to get the historical data.
     - parameter from:      Starts of day with format `YYYY-mm-dd`.
     - parameter to:        Ends of day with format `YYYY-mm-dd`.
     - returns:             The `CandleData` model result by the specified symbol.
     - note:                Before calling the Fugle API, your should specify API token first for this client.
     */
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
    /**
     Get the realtime intraday result data in day from Intraday endpoint.

     Examples of callback:

     ```
     let dataCallback: ((Result<MetaData, ClientError>) -> Void) = {
        switch $0 {
            case .success(let result):
            case .failure(let failures):
        }
     }
     ```

     - parameter type:      Data type implementation for this query, please refer to `MappableDataClass`.
     - parameter symbol:    The symbol id to get data by type.
     - parameter oddLot:    Only get the odd lot data, default is false.
     - parameter callback:  Realtime data callback from websocket subscription.
     - returns:             The promise returned after connection was successfully established.
     - note:                Before calling the Fugle API, your should specify API token first for this client.
     */
    public func streamIntraday<T>(_ type: T.Type, symbol: String, oddLot: Bool = false, callback: ((Result<T, ClientError>) -> Void)?) async throws -> EventLoopPromise<Void>
        where T: MappableDataClass {
        guard let resource: IntradayResource = (type as? ResourceType.Type)?.resource else {
            throw ClientError.unsupportedEroor(info: "invalid resource type")
        }
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
