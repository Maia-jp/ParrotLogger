//
//  LogEntry.swift
//  EcoaStage
//
//  Created by Victor Martins on 01/05/23.
//  Copyright © 2023 Ecoa Les PUC-Rio. All rights reserved.
//

import Foundation

extension LogHelper {
    public struct LogEntry {
        let date: Date
        let logLevel: LogHelper.LogSeverity
        let category: String
        let functionName: String
        let content: String
    }
}
