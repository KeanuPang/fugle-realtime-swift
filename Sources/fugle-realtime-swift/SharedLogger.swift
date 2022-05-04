//
//  SharedLogger.swift
//
//
//  Created by Keanu Pang on 2022/5/3.
//

import Logging

struct SharedLogger {
    static func getLogger(_ label: String) -> Logger {
        var logger = Logger(label: label)
        logger.logLevel = .debug
        return logger
    }
}
