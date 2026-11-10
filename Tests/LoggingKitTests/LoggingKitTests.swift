//
//  LoggingKitTests.swift
//  AppFoundation
//

import Testing
@testable import LoggingKit

/// Records what it was asked to write.
private final class SpyLogger: AppLogger, @unchecked Sendable {
    private(set) var entries: [(level: LogLevel, message: String)] = []

    func log(_ level: LogLevel, _ message: @autoclosure () -> String) {
        entries.append((level, message()))
    }
}

/// Counts how many times a message was built.
private final class MessageCounter: @unchecked Sendable {
    private(set) var count = 0

    func message() -> String {
        count += 1
        return "message"
    }
}

@Suite("LogLevel")
struct LogLevelTests {
    @Test func levelsAreOrderedByImportance() {
        #expect(LogLevel.debug < .info)
        #expect(LogLevel.info < .error)
        #expect(LogLevel.debug < .error)
    }
}

@Suite("AppLogger shortcuts")
struct AppLoggerShortcutTests {
    @Test func eachShortcutWritesItsLevel() {
        let spy = SpyLogger()

        spy.debug("d")
        spy.info("i")
        spy.error("e")

        #expect(spy.entries.map(\.level) == [.debug, .info, .error])
        #expect(spy.entries.map(\.message) == ["d", "i", "e"])
    }
}

@Suite("OSLogLogger")
struct OSLogLoggerTests {
    @Test func buildsTheMessageWhenTheLevelIsWritten() {
        let logger = OSLogLogger(category: "tests", minimumLevel: .debug)
        let counter = MessageCounter()

        logger.debug(counter.message())

        #expect(counter.count == 1)
    }

    @Test func doesNotBuildTheMessageBelowTheMinimumLevel() {
        let logger = OSLogLogger(category: "tests", minimumLevel: .error)
        let counter = MessageCounter()

        logger.debug(counter.message())
        logger.info(counter.message())

        #expect(counter.count == 0)
    }

    @Test func writesTheMinimumLevelItself() {
        let logger = OSLogLogger(category: "tests", minimumLevel: .info)
        let counter = MessageCounter()

        logger.info(counter.message())
        logger.error(counter.message())

        #expect(counter.count == 2)
    }
}

@Suite("NoOpLogger")
struct NoOpLoggerTests {
    @Test func neverBuildsTheMessage() {
        let counter = MessageCounter()

        NoOpLogger().error(counter.message())

        #expect(counter.count == 0)
    }
}

@Suite("LoggerFactory")
struct LoggerFactoryTests {
    @Test func debugFactoryWritesEveryLevel() {
        let logger = DebugLoggerFactory().makeLogger(category: "tests")
        let counter = MessageCounter()

        logger.debug(counter.message())

        #expect(logger is OSLogLogger)
        #expect(counter.count == 1)
    }

    @Test func releaseFactoryWritesOnlyErrors() {
        let logger = ReleaseLoggerFactory().makeLogger(category: "tests")
        let counter = MessageCounter()

        logger.debug(counter.message())
        logger.info(counter.message())
        logger.error(counter.message())

        #expect(counter.count == 1)
    }

    @Test func silentFactoryWritesNothing() {
        let logger = SilentLoggerFactory().makeLogger(category: "tests")

        #expect(logger is NoOpLogger)
    }
}

@Suite("Log")
struct LogTests {
    @Test func debugBuildsLogEveryLevel() {
        // `swift test` builds in Debug, so `Log` uses the debug factory.
        #expect(Log.make("tests") is OSLogLogger)
    }

    @Test func callsFromAnyThreadDoNotCrash() async {
        await withTaskGroup(of: Void.self) { group in
            for index in 0..<50 {
                group.addTask { Log.debug("background \(index)", category: "tests") }
            }
        }
    }
}
