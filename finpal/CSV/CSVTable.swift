//
//  CSVTable.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/23/25.
//

import Foundation

struct CSVTable<Record> {
    private(set) var columns: [CSVColumn<Record>]
    private(set) var configuration: CSVEncoderConfiguration
    
    init(columns: [CSVColumn<Record>], configuration: CSVEncoderConfiguration = .default) {
        self.columns = columns
        self.configuration = configuration
    }
        
    public func export(rows: any Sequence<Record>) -> String {
        ([headers] + allRows(rows: rows)).newlineDelimited
    }
    
    private var headers: String {
        columns.map { $0.header.escapedOutput(configuration: configuration) }.commaDelimited
    }

    private func allRows(rows: any Sequence<Record>) -> [String] {
        rows.map { row in
            columns.map { $0.attribute(row).escapedOutput(configuration: configuration) }.commaDelimited
        }
    }
}
