//
//  LogSeverity.swift
//  EcoaStage
//
//  Created by João Pedro Monteiro Maia on 28/04/23.
//

import Foundation

extension LogHelper {
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

extension LogHelper.LogSeverity: Equatable, Comparable {
    public static func < (lhs: LogHelper.LogSeverity, rhs: LogHelper.LogSeverity) -> Bool {
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
