//
//  OSLogLogger.swift
//  LoggingKit
//

import Foundation
import os

/// Writes to Apple's unified log: Xcode console and Console.app,
/// filterable by subsystem and category.
///
/// Messages are logged as public: never pass raw user data to a logger.
public nonisolated struct OSLogLogger: AppLogger {
    private let logger: Logger
    private let minimumLevel: LogLevel

    public init(
        subsystem: String = Bundle.main.bundleIdentifier ?? "app",
        category: String,
        minimumLevel: LogLevel = .debug
    ) {
        self.logger = Logger(subsystem: subsystem, category: category)
        self.minimumLevel = minimumLevel
    }

    public func log(_ level: LogLevel, _ message: @autoclosure () -> String) {
        guard level >= minimumLevel else { return }

        let text = message()
        switch level {
        case .debug: logger.debug("\(text, privacy: .public)")
        case .info: logger.info("\(text, privacy: .public)")
        case .error: logger.error("\(text, privacy: .public)")
        }
    }
}
