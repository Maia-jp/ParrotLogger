//
//  Logging.swift
//  EcoaStage
//
//  Created by Victor Martins on 30/04/23.
//  Copyright © 2023 Ecoa Les PUC-Rio. All rights reserved.
//

import Foundation
import os.log

fileprivate var _logCache = [ObjectIdentifier: LogHelper]()

fileprivate let logCacheQueue = DispatchQueue(label: "Log Cache Queue")

public protocol Logging { }

extension Logging {
    var log: LogHelper {
        let objectIdentifier = ObjectIdentifier(Self.self)
        return logCacheQueue.sync {
            if let cachedLogger = _logCache[objectIdentifier] {
                return cachedLogger
            } else {
                let newLogger = LogHelper(category: String(describing: Self.self))
                _logCache[objectIdentifier] = newLogger
                return newLogger
            }
        }
    }
}
