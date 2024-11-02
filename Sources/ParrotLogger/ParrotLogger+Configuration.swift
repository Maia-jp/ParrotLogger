//
//  Configuration.swift
//  ParrotLogger
//
//  Created by Victor Martins on 20/10/24.
//

import Foundation

extension ParrotLogger {
    
    public struct Configuration: Sendable {
        var logLevel: LogSeverity? = nil
        var logLevelName: String? = nil
        var category: String
        var functionDescriptionMode: FunctionDescriptionMode = .full
        var dateFormatter: Date.FormatStyle? = nil
        
        public init(logLevel: LogSeverity? = nil, logLevelName: String? = nil, category: String, functionDescriptionMode: FunctionDescriptionMode = .full, dateFormatter: Date.FormatStyle? = nil) {
            self.logLevel = logLevel
            self.logLevelName = logLevelName
            self.category = category
            self.functionDescriptionMode = functionDescriptionMode
            self.dateFormatter = dateFormatter
        }
    }
    
    public static subscript(configuration: Configuration) -> Self {
        Self(
            logLevel: configuration.logLevel,
            logLevelName: configuration.logLevelName,
            category: configuration.category,
            functionDescriptionMode: configuration.functionDescriptionMode,
            dateFormatter: configuration.dateFormatter
        )
    }
    
}
