//
//  CommonError.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import ObjectMapper

class CommonError: Mappable, Error {
    var apiVersion: String?
    var error: ErrorDetails?

    init(error: ErrorDetails) {
        self.error = error
    }

    required init?(map: Map) {}

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

    static func jsonError(rawValue: String) -> CommonError {
        return CommonError(error: ErrorDetails(message: "JSON parse failed: \(rawValue)"))
    }
}

extension Error {
    func toString() -> String {
        (self as? Encodable)?.toString() ?? self.localizedDescription
    }
}
