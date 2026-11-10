# LoggingKit

App-wide logging for Swift apps on top of Apple's unified log (`os.Logger`), with the log policy fixed by the build.

## Requirements

- Swift 6.2+ (Xcode 26+)
- iOS 17+ / macOS 14+

## Installation

In Xcode: **File → Add Package Dependencies…**, paste `https://github.com/alexosnach/LoggingKit.git`.

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/alexosnach/LoggingKit.git", from: "1.0.0"),
],
targets: [
    .target(name: "MyApp", dependencies: ["LoggingKit"]),
]
```


## Quick start

```swift
import LoggingKit

Log.debug("Paywall shown")
Log.info("User opened settings", category: "settings")
Log.error("Purchase failed: \(error)", category: "paywall")
```

Output in the Xcode console / Console.app:

```
[PaywallView.swift:42 onAppear()] Paywall shown
```

- **No setup.** `Log` works from any thread right away.
- **Policy fixed by the build:** Debug builds write every level, Release builds write only `error`. It cannot be changed at runtime.
- **Lazy messages:** the string is built only if the level is actually written.
- Messages are logged as **public** — never pass raw user data (emails, tokens, names) to a logger.

## Injecting a logger

For a class whose job is logging (e.g. a console analytics provider), take an `AppLogger` in `init` instead of calling `Log` directly — it makes the class testable:

```swift
final class ConsoleAnalyticsProvider {
    private let logger: AppLogger
    init(logger: AppLogger = Log.make("analytics")) { self.logger = logger }
    // …
}
```

## API

| Type | Purpose |
|---|---|
| `Log` | Global entry point: `debug`, `info`, `error`, `make(_ category:)` |
| `AppLogger` | Protocol your code depends on |
| `LogLevel` | `debug < info < error` |
| `OSLogLogger` | Writes to the unified log (subsystem + category) |
| `NoOpLogger` | Writes nothing |
| `LoggerFactory` | `DebugLoggerFactory`, `ReleaseLoggerFactory`, `SilentLoggerFactory` (tests/previews) |

## Running tests

```bash
swift test
```

## License

MIT — see [LICENSE](LICENSE).
