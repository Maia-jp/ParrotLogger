//
//  ParrotLogger
//

import Foundation

extension ParrotLogger {
    public struct LogEntry {
        let date: Date
        let logLevel: ParrotLogger.LogSeverity
        let category: String
        let functionName: String
        let content: String
    }
}
