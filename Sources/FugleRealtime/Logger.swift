//
//  Logger.swift
//
//
//  Created by Keanu Pang on 2022/5/17.
//

import Foundation

protocol Logging: Sendable {
    func debug(_ debug: String)
    func info(_ info: String)
    func warning(_ warning: String)
    func error(_ error: String)
    func fatal(_ fatal: String)
}

struct Logger: Logging {
    let category: String

    init(category: String) {
        self.category = category
    }

    func debug(_ debug: String) {
        log(level: "debug", message: debug)
    }

    func info(_ info: String) {
        log(level: "info", message: info)
    }

    func warning(_ warning: String) {
        log(level: "warning", message: warning)
    }

    func error(_ error: String) {
        log(level: "error", message: error)
    }

    func fatal(_ fatal: String) {
        log(level: "fatal", message: fatal)
    }

    private func log(level: String, message: String) {
        guard ClientConfig.loggerDisabled() == false else { return }
        Swift.print("[\(category)] \(level): \(message)")
    }
}

extension Logging where Self == Logger {
    static func print(category: String) -> Self {
        return Logger(category: category)
    }

    static func defaultLogger(category: String) -> Logger {
        return .print(category: category)
    }
}
