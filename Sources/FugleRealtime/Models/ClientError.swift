//
//  ClientError.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import ObjectMapper

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
        var code: UInt32?
        var message: String?

        init(message: String) {
            self.message = message
        }

     public    required init?(map: Map) {}

        public    func mapping(map: Map) {
            code <- map["code"]
            message <- map["message"]
        }
    }

    static func unexpectedError(info: String) -> ClientError {
        return ClientError(error: ErrorDetails(message: "Unexpected error occured by \(info)"))
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
