//
//  AppLogger.swift
//  LoggingKit
//

import Foundation

/// Writes log messages. Code depends on this protocol, never on a concrete logger,
/// so the build decides in one place whether logs are written.
///
/// Named `AppLogger` because `Logger` is already a type in the `os` framework.
///
/// One logger instance serves one category (`"analytics"`, `"onboarding"`):
/// pass each part of the app its own.
public nonisolated protocol AppLogger: Sendable {
    /// `message` is built only when the level is actually written.
    func log(_ level: LogLevel, _ message: @autoclosure () -> String)
}

nonisolated extension AppLogger {
    public func debug(_ message: @autoclosure () -> String) { log(.debug, message()) }
    public func info(_ message: @autoclosure () -> String) { log(.info, message()) }
    public func error(_ message: @autoclosure () -> String) { log(.error, message()) }
}
