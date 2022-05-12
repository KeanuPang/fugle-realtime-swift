//
//  CommonError.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import ObjectMapper

class CommonError: MappableData, Error {
    var apiVersion: String?
    var info: Info?
    var error: ErrorDetails?

    required init?(map: Map) {}

    init(error: ErrorDetails) {
        self.error = error
    }

    func mapping(map: Map) {
        apiVersion <- map["apiVersion"]
        error <- map["error"]
    }

    class ErrorDetails: Mappable {
        var code: UInt32?
        var message: String?

        init(message: String) {
            self.message = message
        }

        required init?(map: Map) {}

        func mapping(map: Map) {
            code <- map["code"]
            message <- map["message"]
        }
    }

    static func unknownError(info: String) -> CommonError {
        return CommonError(error: ErrorDetails(message: "Unknown error occured by \(info)"))
    }

    static func unsupportedEroor(info: String) -> CommonError {
        return CommonError(error: ErrorDetails(message: "Unsupported operation: \(info)"))
    }

    static func jsonError(rawValue: String) -> CommonError {
        return CommonError(error: ErrorDetails(message: "JSON parse failed: \(rawValue)"))
    }
}

extension Error {
    func toString() -> String {
        (self as? CommonError)?.toJSONString(prettyPrint: true) ?? self.localizedDescription
    }
}
