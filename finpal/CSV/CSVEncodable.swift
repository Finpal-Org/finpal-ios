//
//  CSVEncodable.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/23/25.
//

import Foundation

protocol CSVEncodable {
    func encode(configuration: CSVEncoderConfiguration) -> String
}

extension String: CSVEncodable {
    
    func encode(configuration: CSVEncoderConfiguration) -> String { self }
}

extension Date: CSVEncodable {
    
    func encode(configuration: CSVEncoderConfiguration) -> String {
        switch configuration.dateEncodingStrategy {
            
        case .deferredToDate:
            String(self.timeIntervalSinceReferenceDate)
        case .iso8601:
            ISO8601DateFormatter().string(from: self)
        case .formatted(let dateFormatter):
            dateFormatter.string(from: self)
        case .custom(let customFunc):
            customFunc(self)
        }
    }
}

extension Int: CSVEncodable {
    
    func encode(configuration: CSVEncoderConfiguration) -> String { String(self) }
}

extension UUID: CSVEncodable {
    
    func encode(configuration: CSVEncoderConfiguration) -> String { uuidString }
}

extension Double: CSVEncodable {
    
    func encode(configuration: CSVEncoderConfiguration) -> String { String(self) }
}

extension Float: CSVEncodable {
    
    func encode(configuration: CSVEncoderConfiguration) -> String {
        String(format: "%.2f", self)
    }
}

extension Bool: CSVEncodable {
    
    func encode(configuration: CSVEncoderConfiguration) -> String {
        let (trueValue, falseValue) = configuration.boolEncodingStrategy.encodingValues
        return self == true ? trueValue : falseValue
    }
}

extension Optional: CSVEncodable where Wrapped: CSVEncodable {
    
    func encode(configuration: CSVEncoderConfiguration) -> String {
        switch self {
        case .none:
            ""
        case .some(let wrapped):
            wrapped.encode(configuration: configuration)
        }
    }
}

extension CSVEncodable {
    
    internal func escapedOutput(configuration: CSVEncoderConfiguration) -> String {
        let output = self.encode(configuration: configuration)
        if output.contains(",") || output.contains("\"") || output.contains(#"\n"#) || output.hasPrefix(" ") || output.hasSuffix(" ") {
            let escapedQuotes = output.replacingOccurrences(of: "\"", with: "\"\"")
            return "\"\(escapedQuotes)\""
        } else {
            return output
        }
    }
}
