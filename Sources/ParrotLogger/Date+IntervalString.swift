//
//  File.swift
//  HostCommon
//
//  Created by Victor Martins on 13/10/24.
//

import Foundation
#if canImport(UIKit)
import UIKit

public nonisolated(unsafe) var maxFramesPerSecond = 60
#endif

public extension Date {
    @MainActor
    static func formattedTimeIntervalSince(_ startDate: Date) -> String {
        return Date.now.formattedTimeIntervalSince(startDate)
    }
    
    func formattedTimeIntervalSince(_ startDate: Date) -> String {
        let interval = Date.now.timeIntervalSince(startDate)
        var framesUsedDesc: String = ""
                
        #if canImport(UIKit)
        let framesUsed = Int((interval/(1.0/Double(maxFramesPerSecond))).rounded(.towardZero))
        framesUsedDesc = " / \(framesUsed)"
        #endif
        
        return "\(interval.formatted(.number.precision(.fractionLength(1...3)))) s\(framesUsedDesc)"
    }
}
