# ParrotLogger 🦜🦜

ParrotLogger is a Swift logging framework designed to provide developers with a simple and flexible way to log messages and events in their applications. ParrotLogger is fully written in Swift and provides a variety of features and customization options to meet the needs of any project.

## Features
- Log levels: trace, debug, info, notice, warning, error, critical
- Customizable log output format
- Flexible log destinations: console, file, and custom destinations
- Privacy strings
- Extensible and customizable
- Configurable via environment variables

## Usage
### Basic Usage
todo
### Setting log severity
There are seven levels available. From less severe to more severe, they are:
- `trace` – Appropriate for messages that contain information only when debugging a program.
- `debug` – Appropriate for messages that contain information normally of use only when debugging a program.
- `info` – Appropriate for informational messages.
- `notice` – Appropriate for conditions that are not error conditions, but that may require special handling.
- `warning` – Appropriate for messages that are not error conditions, but more severe than `notice`
- `error` – Appropriate for error conditions.
- `critical` – Appropriate for critical error conditions that usually require immediate attention.

When shown on the console, the notice, warning, error and critical levels have colored circles on their side, to catch more attention.
### Customizing the output
todo
#### Privacy Strings
Whether a given variable that is written on a log message shows up on the release configuration and how it will show up.
- There are 7 configurations available.
- One of the is called public, where the text is shown both on the debug configuration and on the release configuration.
- The other ones are under the name of sensitive. There are variations on how the sensitive data will be shown.
    - The first way is by hiding it. In this case, the data is replaced by the text “`<private>`”, just like Apple's OSLog framework chose to do.
    - The other way is by showing a prefix or suffix of some size. If the data gets truncated, an ellipsis (…) is shown at the appropriate position.
    - The other way is by showing the hash of the data. This enables us to hide the data itself while still being able to know if two log messages are referring to the same data, because if it's the same data, then the hash is going to be the same. The data is replaced by a text like “`<hash: 3298578276978312833>`”.
    - And one final way is by showing asteriscs. This keeps the number of characters of the original data, but hides it's content.
### Logging to a file
todo

### External Observability

The `LogHelper` class also implements enables external observers of new log entries.

A publisher called `newLogEntryPublisher` is a static property of the `LogHelper` class. It's a `PassthroughPublisher` and it's output is `Void`. That means that no entries are outputted by the publisher, just a signal that represents that “new entries are available”.

An `Array` of all log entries on this session is also declared as static and is readable from anywhere. And a convenience computed property that represents the latest log entry was also implemented as static and is readable from anywhere.
