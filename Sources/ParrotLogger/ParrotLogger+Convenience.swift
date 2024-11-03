//
//  ParrotLogger+Convenience.swift
//  ParrotLogger
//
//  Created by Victor Martins on 20/10/24.
//

import Foundation

// MARK: - Specific level log methods
extension ParrotLogger {
    /**
     Logs a trace message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    public func trace(
        _ message: LogString,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .trace,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a debug message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    public func debug(
        _ message: LogString,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .debug,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a info message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    public func info(
        _ message: LogString,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .info,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a notice message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    public func notice(
        _ message: LogString,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .notice,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a warning message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    public func warning(
        _ message: LogString,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .warning,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a error message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    public func error(
        _ message: LogString,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .error,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a critical message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    public func critical(
        _ message: LogString,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(message.rawString + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .critical,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
}

// MARK: - Any
extension ParrotLogger {
    
    /**
     Logs a trace message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    @_disfavoredOverload
    public func trace(
        _ item: Any,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item) + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .trace,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a debug message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    @_disfavoredOverload
    public func debug(
        _ item: Any,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item) + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .debug,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a info message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    @_disfavoredOverload
    public func info(
        _ item: Any,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item) + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .info,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a notice message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    @_disfavoredOverload
    public func notice(
        _ item: Any,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item) + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .notice,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a warning message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    @_disfavoredOverload
    public func warning(
        _ item: Any,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item) + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .warning,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a error message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    @_disfavoredOverload
    public func error(
        _ item: Any,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item) + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .error,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
    
    /**
     Logs a critical message.
     
     - Parameters:
     - message: The message to log.
     - filename: The name of the file from which the message was logged.
     - line: The line number from which the message was logged.
     - column: The column number from which the message was logged.
     - functionName: The name of the function from which the message was logged.
     */
    @_disfavoredOverload
    public func critical(
        _ item: Any,
        _ startDate: Date? = nil,
        filename: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        functionName: String = #function
    ) {
        self.log(String(describing: item) + (startDate != nil ? Date.now.formattedTimeIntervalSince(startDate!) : ""), .critical,
                 filename: filename, line: line, columns: column, functionName: functionName)
    }
}
