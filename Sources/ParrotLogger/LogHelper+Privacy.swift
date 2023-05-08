//
//  StringInterpolation+Privacy.swift
//  EcoaStage
//
//  Created by João Pedro Monteiro Maia on 28/04/23.
//

import Foundation
import os.log

extension LogHelper {
    public enum LogPrivacyLevel {
        /// Always print
        case `public`

        /// Print only when debugging
        case sensitive(SentitivityConfiguration)
        
        public enum SentitivityConfiguration {
            case showPrefix(Int)
            case showSuffix(Int)
            case showHash
            case showAsteriscs
            case hide
        }
    }
}

public struct PrivacyStringInterpolation: StringInterpolationProtocol {
    fileprivate var value: String = ""
    
    public init(literalCapacity: Int, interpolationCount: Int) {
        self.value.reserveCapacity(literalCapacity)
    }
    
    public mutating func appendLiteral(_ literal: String) {
        self.value.append(literal)
    }
    
    public mutating func appendInterpolation(_ item: Any, privacy: LogHelper.LogPrivacyLevel = .public) {
        switch privacy {
        case .public:
            self.value.append(String(describing: item))
        case .sensitive(let sensitivityConfiguration):
            #if DEBUG
            self.value.append(String(describing: item))
            #else
//            let protectedString = String(repeating: "*", count: string.rawString.count)
//            self.value.append(protectedString.hashValue.description.prefix(max(8, string.rawString.count)).description)
//            self.value.append(string.rawString.prefix(3).description)
            switch sensitivityConfiguration {
            case .showPrefix(let prefixSize):
                let itemDescription = String(describing: item)
                let ellipsis = prefixSize < itemDescription.count ? "..." : ""
                self.value.append(itemDescription.prefix(prefixSize).description + ellipsis)
            case .showSuffix(let suffixSize):
                let itemDescription = String(describing: item)
                let ellipsis = suffixSize < itemDescription.count ? "..." : ""
                self.value.append(ellipsis + itemDescription.suffix(suffixSize).description)
            case .showHash:
                self.value.append("<hash: \(String(describing: item).hashValue.description)>")
            case .showAsteriscs:
                self.value.append(String(repeating: "*", count: String(describing: item).count))
            case .hide:
                self.value.append("<private>")
            }
            #endif
        }
    }
}

public struct LogString: ExpressibleByStringInterpolation {
    var rawString: String
    
    public init(stringInterpolation: PrivacyStringInterpolation) {
        self.rawString = String(stringInterpolation.value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.rawString = String(unicodeScalarLiteral: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.rawString = String(extendedGraphemeClusterLiteral: value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.rawString = value
    }
}
////OSLogMessage.StringInterpolation
//func b(_ s: LogString) {
//    print(s.rawString)
//}
//let a = b("a \("x", privacy: .sensitive)")
////let c = "a \("x", privacy: .sensitive)"
//let loger = Logger(subsystem: "", category: "")
//let z = loger.debug("\(10.0, format: .fixed(precision: 10))")
////let zz = "\(10.0, format: .fixed(precision: 10))"
