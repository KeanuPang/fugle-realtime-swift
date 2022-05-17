//
//  ClientError.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import ObjectMapper

public enum ClientErrorCode: String {
    case invalidTokenOrUrl
    case unexpectedError

    func toError(_ info: String) -> ClientError {
        switch self {
        case .invalidTokenOrUrl:
            return ClientError.unexpectedError(code: self.rawValue, info: info)
        case .unexpectedError:
            return ClientError.unexpectedError(code: self.rawValue, info: info)
        }
    }
}

public class ClientError: MappableData, Error {
    public var apiVersion: String?
    public var info: Info?
    public var error: ErrorDetails?

    public required init?(map: Map) {}

    init(error: ErrorDetails) {
        self.error = error
    }

    public func mapping(map: Map) {
        apiVersion <- map["apiVersion"]
        error <- map["error"]
    }

    public class ErrorDetails: Mappable {
        public var code: String?
        public var codeNumber: UInt32?
        public var message: String?

        init(code: String? = nil, message: String) {
            self.code = code
            self.message = message
        }

        public required init?(map: Map) {}

        public func mapping(map: Map) {
            codeNumber <- map["code"]
            message <- map["message"]

            if let number = codeNumber {
                code = "\(number)"
            }
        }
    }

    static func unexpectedError(code: String? = nil, info: String) -> ClientError {
        return ClientError(error: ErrorDetails(code: code, message: "Unexpected error occured by \(info)"))
    }

    static func unsupportedEroor(info: String) -> ClientError {
        return ClientError(error: ErrorDetails(message: "Unsupported operation: \(info)"))
    }

    static func jsonError(rawValue: String) -> ClientError {
        return ClientError(error: ErrorDetails(message: "JSON parse failed: \(rawValue)"))
    }
}

extension Error {
    func toString() -> String {
        (self as? ClientError)?.toJSONString(prettyPrint: true) ?? self.localizedDescription
    }
}
