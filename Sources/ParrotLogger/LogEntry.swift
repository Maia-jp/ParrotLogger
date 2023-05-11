//
//  ParrotLogger
//

import Foundation

extension ParrotLogger {
    /// This code defines a Swift struct called LogEntry. It represents a single log entry,
    public struct LogEntry {
        let date: Date
        let logLevel: ParrotLogger.LogSeverity
        let category: String
        let functionName: String
        let content: String
    }
}
