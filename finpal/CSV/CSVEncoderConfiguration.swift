//
//  CSVEncoderConfiguration.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/24/25.
//

import Foundation

public struct CSVEncoderConfiguration: Sendable {
    public private(set) var dateEncodingStrategy: DateEncodingStrategy = .iso8601
    public private(set) var boolEncodingStrategy: BoolEncodingStrategy = .trueFalse
    
    public init(
        dateEncodingStrategy: DateEncodingStrategy = .iso8601,
        boolEncodingStrategy: BoolEncodingStrategy = .trueFalse
    ) {
        self.dateEncodingStrategy = dateEncodingStrategy
        self.boolEncodingStrategy = boolEncodingStrategy
    }
    
    public enum DateEncodingStrategy: Sendable {
        case deferredToDate
        case iso8601
        case formatted(DateFormatter)
        case custom(@Sendable (Date) -> String)
    }
    
    public enum BoolEncodingStrategy: Sendable {
        case trueFalse
        case trueFalseUppercase
        case yesNo
        case yesNoUppercase
        case integer
        case custom(true: String, false: String)
    }
    
    public static let `default`: CSVEncoderConfiguration = CSVEncoderConfiguration()
}

internal extension CSVEncoderConfiguration.BoolEncodingStrategy {
    var encodingValues: (String, String) {
        switch self {
        case .trueFalse:
            return ("true", "false")
        case .trueFalseUppercase:
            return ("TRUE", "FALSE")
        case .yesNo:
            return ("yes", "no")
        case .yesNoUppercase:
            return ("YES", "NO")
        case .integer:
            return ("1", "0")
        case .custom(let trueValue, let falseValue):
            return (trueValue, falseValue)
        }
    }
}
