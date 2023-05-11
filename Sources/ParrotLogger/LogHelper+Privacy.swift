//
//  ParrotLogger
//

import Foundation
import os.log

extension ParrotLogger {
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
    
    public mutating func appendInterpolation(_ item: Any, privacy: ParrotLogger.LogPrivacyLevel = .public) {
        switch privacy {
        case .public:
            self.value.append(String(describing: item))
        case .sensitive(let sensitivityConfiguration):
            #if DEBUG
            self.value.append(String(describing: item))
            #else
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
