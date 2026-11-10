//
//  LogLevel.swift
//  LoggingKit
//

import Foundation

/// How important a log message is. Ordered: `debug < info < error`.
public nonisolated enum LogLevel: Int, Comparable, Sendable {
    case debug
    case info
    case error

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
