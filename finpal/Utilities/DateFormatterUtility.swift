//
//  DateFormatterUtility.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/12/25.
//

import SwiftUI

enum DateFormat {
    case standard        // yyyy-MM-dd HH:mm:ss
    case mediumDate      // MMM d, yyyy
    case timeOnly        // hh:mm a
    case dayAndMonth     // EEE, d MMM
    case monthOnly       // MMMM
}

final class DateFormatterUtility: Sendable {
    
    static let shared = DateFormatterUtility()
    
    private init() { }
    
    func formatter(for format: DateFormat) -> DateFormatter {
        switch format {
        case .standard:
            return DateFormatterUtility.standardFormatter
        case .mediumDate:
            return DateFormatterUtility.mediumDateFormatter
        case .timeOnly:
            return DateFormatterUtility.timeOnlyFormatter
        case .dayAndMonth:
            return DateFormatterUtility.dayAndMonthFormatter
        case .monthOnly:
            return DateFormatterUtility.monthOnlyFormatter
        }
    }
    
    func string(from date: Date, format: DateFormat) -> String {
        return formatter(for: format).string(from: date)
    }
    
    func date(from string: String, format: DateFormat) -> Date? {
        return formatter(for: format).date(from: string)
    }
    
    private static let standardFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    private static let timeOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    private static let dayAndMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        return formatter
    }()
    
    private static let monthOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
}
