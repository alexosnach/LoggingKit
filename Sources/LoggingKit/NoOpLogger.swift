//
//  NoOpLogger.swift
//  LoggingKit
//

import Foundation

/// Logger that writes nothing: for builds where logs are off.
public nonisolated struct NoOpLogger: AppLogger {
    public init() {}

    public func log(_ level: LogLevel, _ message: @autoclosure () -> String) {}
}
