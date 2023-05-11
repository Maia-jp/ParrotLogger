//
//  ParrotLogger
//

import Foundation

extension ParrotLogger {
    public enum LogSeverity: String {
        case trace
        case debug
        case info
        case notice
        case warning
        case error
        case critical
    }
}

extension ParrotLogger.LogSeverity: Equatable, Comparable {
    public static func < (lhs: ParrotLogger.LogSeverity, rhs: ParrotLogger.LogSeverity) -> Bool {
        lhs.asInt < rhs.asInt
    }
    
    private var asInt: Int {
        switch self {
        case .trace:    return 0
        case .debug:    return 1
        case .info:     return 2
        case .notice:   return 3
        case .warning:  return 4
        case .error:    return 5
        case .critical: return 6
        }
    }
}
