//
//  Date+EXT.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/4/25.
//

import Foundation

extension Date {
    
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
