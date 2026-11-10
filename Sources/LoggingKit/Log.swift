//
//  Log.swift
//  LoggingKit
//

import Foundation

/// The app-wide entry point for logs (Ambient Context): call it from anywhere,
/// on any thread, without passing a logger around.
///
/// ```swift
/// Log.debug("Paywall shown")
/// Log.error("Purchase failed: \(error)", category: "paywall")
/// ```
///
/// Each message carries where it was written: `[PaywallView.swift:42 onAppear()] Paywall shown`.
///
/// Where the logs go is fixed by the build: every level in Debug, only
/// errors in Release. Nothing can change it at runtime, so it is safe from
/// any thread and needs no setup.
///
/// Classes whose whole job is logging (such as an analytics console provider)
/// take an ``AppLogger`` in `init` instead: `Log.make("analytics")`.
public nonisolated enum Log {
    /// Creates every logger. A constant: chosen once by the build.
    private static let factory: LoggerFactory = {
        #if DEBUG
        DebugLoggerFactory()
        #else
        ReleaseLoggerFactory()
        #endif
    }()

    /// The category used when a call does not name one.
    public static let defaultCategory = "app"

    /// A logger for one category, for classes that take it in `init`.
    public static func make(_ category: String) -> AppLogger {
        factory.makeLogger(category: category)
    }

    public static func debug(
        _ message: @autoclosure () -> String,
        category: String = defaultCategory,
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        write(.debug, message(), category, fileID, function, line)
    }

    public static func info(
        _ message: @autoclosure () -> String,
        category: String = defaultCategory,
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        write(.info, message(), category, fileID, function, line)
    }

    public static func error(
        _ message: @autoclosure () -> String,
        category: String = defaultCategory,
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        write(.error, message(), category, fileID, function, line)
    }

    private static func write(
        _ level: LogLevel,
        _ message: @autoclosure () -> String,
        _ category: String,
        _ fileID: String,
        _ function: String,
        _ line: Int
    ) {
        make(category).log(level, "[\(fileName(fileID)):\(line) \(function)] \(message())")
    }

    /// `MyApp/PaywallView.swift` → `PaywallView.swift`.
    private static func fileName(_ fileID: String) -> Substring {
        fileID.split(separator: "/").last ?? Substring(fileID)
    }
}
