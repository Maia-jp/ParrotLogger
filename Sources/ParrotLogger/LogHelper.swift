//
//  LogHelper.swift
//  EcoaStage
//
//  Created by João Pedro Monteiro Maia on 28/04/23.
//

import Foundation
import Combine

/// TODO: UnitTesting
/// TODO: Explain @_disfavoredOverload
public class LogHelper: ObservableObject {
    
    public static let generalLogLevel: LogSeverity = getGeneralLogLevel()
    public var logLevel: LogSeverity
    
    public let category: String
    public let dateFormatter: DateFormatter
    
    @MainActor static public var latestEntry: LogEntry? { sessionEntries.last }
    @MainActor static public private(set) var sessionEntries = [LogEntry]()
    
    @MainActor static var newLogEntryPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: - Initialization
    public init(
        logLevel: LogSeverity? = nil,
        category: String,
        dateFormatter: DateFormatter? = nil
    ) {
        self.category = category
        let logLevelForCategory = Self.getLogLevel(forCategory: category)
        if logLevel != nil && logLevelForCategory != nil {
            print("Log level specified on the \(category) LogHelper's initialization overriding the value from the environment variable.")
        }
        self.logLevel = logLevel ?? logLevelForCategory ?? Self.generalLogLevel
        self.dateFormatter = dateFormatter ?? Self.defaultDateformatter
    }
    
    // MARK: - Static helper methods
    private static var defaultDateformatter = {
        let dtf = DateFormatter()
        dtf.dateFormat = "HH:mm:ss.SS"
        return dtf
    }()
    
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
    
    private static func getLogLevel(forCategory category: String) -> LogSeverity? {
        let specificLogLevelID = "LOG_LEVEL_\(category.uppercased())"
        if let specificLogLevelVariable = ProcessInfo.processInfo.environment[specificLogLevelID] {
            if let specificLogLevel = LogSeverity(rawValue: specificLogLevelVariable.lowercased()) {
                return specificLogLevel
            } else {
                print("Invalid \(specificLogLevelID) environment variable")
                return nil
            }
        }
        return nil
    }
    
    // MARK: - Log implementation
    @discardableResult
    private func log(
        _ input: String,
        _ messageLogLevel: LogSeverity?,
        filename: String,
        line: Int,
        columns: Int,
        functionName: String
    ) -> String? {
        let messageLogLevel = messageLogLevel ?? self.logLevel
        guard messageLogLevel >= self.logLevel else { return nil }
        
        let logEntryTime = Date.now
        let message = "\(self.dateFormatter.string(from: logEntryTime)) \(messageLogLevel.alignedDescription) [\(category)\(functionName.isEmpty ? "" : " ")\(functionName)] \(input)"
        
        print(message)
        
        self.objectWillChange.send()
        let newLogEntry = LogEntry(
            date: logEntryTime,
            logLevel: messageLogLevel,
            category: category,
            functionName: functionName,
            content: input
        )
        Task { @MainActor in
            LogHelper.newLogEntryPublisher.send()
            LogHelper.sessionEntries.append(newLogEntry)
        }
        
        return message
    }
    
    
}

extension LogHelper.LogSeverity {
    fileprivate var alignedDescription: String {
        switch self {
        case .trace:    return "   TRACE   "
        case .debug:    return "   DEBUG   "
        case .info:     return "    INFO   "
        case .notice:   return "  NOTICE ⚪️"
        case .warning:  return " WARNING 🟡"
        case .error:    return "   ERROR 🔴"
        case .critical: return "CRITICAL ⚫️"
        }
    }
}


// MARK: - Specific level log methods
extension LogHelper {
    public func trace(
        _ message: LogString,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString, .trace,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    public func debug(
        _ message: LogString,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString, .debug,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    public func info(
        _ message: LogString,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString, .info,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    public func notice(
        _ message: LogString,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString, .notice,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    public func warning(
        _ message: LogString,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString, .warning,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    public func error(
        _ message: LogString,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString, .error,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    public func critical(
        _ message: LogString,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString, .critical,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
}

// MARK: - Any
extension LogHelper {
    
    @_disfavoredOverload
    public func trace(
        _ item: Any,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item), .trace,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    @_disfavoredOverload
    public func debug(
        _ item: Any,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item), .debug,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    @_disfavoredOverload
    public func info(
        _ item: Any,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item), .info,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    @_disfavoredOverload
    public func notice(
        _ item: Any,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item), .notice,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    @_disfavoredOverload
    public func warning(
        _ item: Any,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item), .warning,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    @_disfavoredOverload
    public func error(
        _ item: Any,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item), .error,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    @_disfavoredOverload
    public func critical(
        _ item: Any,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item), .critical,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
}
