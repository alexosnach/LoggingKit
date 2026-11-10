//
//  LoggerFactory.swift
//  LoggingKit
//

import Foundation

/// Creates the loggers of the whole app, one per category.
///
/// The Composition Root picks one factory for the build, so every logger
/// in the app follows the same policy and `#if DEBUG` appears only there.
public nonisolated protocol LoggerFactory: Sendable {
    func makeLogger(category: String) -> AppLogger
}

/// Debug builds: every level goes to the unified log.
public nonisolated struct DebugLoggerFactory: LoggerFactory {
    public init() {}

    public func makeLogger(category: String) -> AppLogger {
        OSLogLogger(category: category, minimumLevel: .debug)
    }
}

/// Release builds: only errors, so a bug on a user's device leaves a trace
/// while debug noise stays out.
public nonisolated struct ReleaseLoggerFactory: LoggerFactory {
    public init() {}

    public func makeLogger(category: String) -> AppLogger {
        OSLogLogger(category: category, minimumLevel: .error)
    }
}

/// No logs at all: for tests and previews that should stay silent.
public nonisolated struct SilentLoggerFactory: LoggerFactory {
    public init() {}

    public func makeLogger(category: String) -> AppLogger {
        NoOpLogger()
    }
}
