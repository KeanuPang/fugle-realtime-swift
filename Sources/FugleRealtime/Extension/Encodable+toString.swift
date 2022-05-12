//
//  Encodable+toString.swift
//
//
//  Created by Keanu Pang on 2022/5/4.
//

import Foundation

extension Encodable {
    func toString() -> String {
        if let data = try? JSONEncoder().encode(self) {
            if let json = String(data: data, encoding: .utf8) {
                return json
            }
        }
        return ""
    }
}
