//
//  ParrotLogger
//

import Foundation
import Combine

/// `ParrotLogger` is a logging utility class that provides a simple way to log messages with different log severities.
public final class ParrotLogger: Sendable, ObservableObject {
    
    public static let generalLogLevel: LogSeverity = getGeneralLogLevel()
    public let logLevel: LogSeverity
    public let overridenLogLevelName: String?
    
    public let category: String
    public let dateFormatter: Date.FormatStyle
    public enum FunctionDescriptionMode: Sendable {
        case full, nameOnly, omitted
    }
    public let functionDescriptionMode: FunctionDescriptionMode
    
    @MainActor static public private(set) var sessionEntries = [LogEntry]()
    
    @MainActor static public var latestEntry: LogEntry? { sessionEntries.last }
    @MainActor static public var newLogEntryPublisher = PassthroughSubject<Void, Never>()
    
    
    // MARK: - Initialization
    /// Initializes a new instance of ParrotLogger.
    /// - Parameters:
    ///   - logLevel: The minimum log level that this logger will print. If not provided, the logger will use the default log level for the given category or the general log level if no specific log level is defined for the category.
    ///   - category: The name of the category that this logger will log.
    ///   - dateFormatter: The date formatter used to format the timestamps in the log messages. If not provided, the logger will use the default date formatter.
    public init(
        logLevel: LogSeverity? = nil,
        logLevelName: String? = nil,
        category: String,
        functionDescriptionMode: FunctionDescriptionMode = .full,
        dateFormatter: Date.FormatStyle? = nil
    ) {
        self.category = category
        if let logLevelName {
            self.overridenLogLevelName = String(repeating: " ", count: 12 - logLevelName.count) + logLevelName
        } else {
            self.overridenLogLevelName = nil
        }
        self.functionDescriptionMode = functionDescriptionMode
        let logLevelForCategory = Self.getLogLevel(forCategory: category)
        if logLevel != nil && logLevelForCategory != nil {
            print("Log level specified on the \(category) LogHelper's initialization overriding the value from the environment variable.")
        }
        self.logLevel = logLevel ?? logLevelForCategory ?? Self.generalLogLevel
        self.dateFormatter = dateFormatter ?? Self.defaultDateformatter
    }
    
    // MARK: - Static helper methods
    private static let defaultDateformatter = Date.FormatStyle()
        .hour(.twoDigits(amPM: .omitted))
        .minute(.twoDigits)
        .second(.twoDigits)
        .secondFraction(.fractional(3))
        .locale(Locale(identifier: "en_US_POSIX"))
    
    /// This method retrieves the general log level from the environment variable LOG_LEVEL, and returns the corresponding LogSeverity enum case.
    /// If the environment variable is not set or contains an invalid value, the method returns the default log level .trace.
    /// - Returns: A LogSeverity enum case representing the general log level.
    private static func getGeneralLogLevel() -> LogSeverity {
        let generalLogLevelID = "LOG_LEVEL"
        if let generalLogLevelVariable = ProcessInfo.processInfo.environment[generalLogLevelID] {
            if let generalLogLevel = LogSeverity(rawValue: generalLogLevelVariable.lowercased()) {
                return generalLogLevel
            } else {
                print("Invalid LOG_LEVEL environment variable, using trace as fallback")
                return .trace
            }
        }
        return .trace
    }
    
    /// Gets the log severity level for a given category.
    /// - Parameter category: The category for which to retrieve the log severity level.
    /// - Returns: The log severity level for the given category or nil if no log severity level was found.
    private static func getLogLevel(forCategory category: String) -> LogSeverity? {
        let env = ProcessInfo.processInfo.environment
        
        let specificLogLevelIDPrefix = "LOG_LEVEL_\(category)".uppercased()
        let specificLogLevelIDSuffix = "\(category)_LOG_LEVEL".uppercased()
        
        guard let specificLogLevelVariable = env[specificLogLevelIDPrefix] ?? env[specificLogLevelIDSuffix] else {
            return nil
        }
        
        guard let specificLogLevel = LogSeverity(rawValue: specificLogLevelVariable.lowercased()) else {
            print("Invalid log level environment variable for category \(category.debugDescription)")
            return nil
        }
        
        return specificLogLevel
    }
    
    // MARK: - Log implementation
    /**
    Logs a message.
     
     - Parameters:
        - input: The message to log.
        - messageLogLevel: The log severity level for the message. If nil, uses the logger's default log level.
        - filename: The name of the file from which the message was logged.
        - line: The line number from which the message was logged.
        - columns: The column number from which the message was logged.
        - functionName: The name of the function from which the message was logged.
     - Returns: The message that was logged or nil if the message was filtered out based on the log severity level.

     This method logs a message to the console and stores a new LogEntry object with the message content, log severity level, category, function name, and timestamp. The log severity level is determined by the "messageLogLevel" parameter or, if nil, by the logger's default log level. The log entry is then added to the logger's session entries. If the message is filtered out based on the log severity level, the method returns nil. Otherwise, it returns the message that was logged.
    **/
    @discardableResult
    func log(
        _ input: String,
        _ messageLogLevel: LogSeverity?,
        filename: String,
        line: Int,
        columns: Int,
        functionName: String
    ) -> String? {
        let messageLogLevel = messageLogLevel ?? self.logLevel
        guard messageLogLevel >= self.logLevel else { return nil }
        
        let logEntryTime: Date = Date()
        
        let preparedFunctionName: String
        switch functionDescriptionMode {
        case .full:
            preparedFunctionName = functionName
        case .nameOnly:
            if let functionName = functionName.split(separator: "(").first {
                preparedFunctionName = String(functionName)
            } else {
                preparedFunctionName = ""
            }
        case .omitted:
            preparedFunctionName = ""
        }
        
        let message = "\(logEntryTime.formatted(dateFormatter)) \(overridenLogLevelName ?? messageLogLevel.alignedDescription) [\(category)\(preparedFunctionName.isEmpty ? "" : " ")\(preparedFunctionName)] \(input)"
        
        print(message)
        
        Task(priority: .utility) {
            let newLogEntry = LogEntry(
                date: logEntryTime,
                logLevel: messageLogLevel,
                category: category,
                functionName: functionName,
                content: input
            )
            await self.appendToSharedHistory(newLogEntry)
        }
        
        return message
    }
    
    @MainActor
    private func appendToSharedHistory(_ newLogEntry: LogEntry) {
        self.objectWillChange.send()
        Self.sessionEntries.append(newLogEntry)
        Self.newLogEntryPublisher.send()
    }
    
}

extension ParrotLogger.LogSeverity {
    fileprivate var alignedDescription: String {
        switch self {
        case .trace:    return "     TRACE   "
        case .debug:    return "     DEBUG   "
        case .info:     return "      INFO   "
        case .notice:   return "    NOTICE ⚪️"
        case .warning:  return "   WARNING 🟡"
        case .error:    return "     ERROR 🔴"
        case .critical: return "  CRITICAL ⚫️"
        }
    }
}
