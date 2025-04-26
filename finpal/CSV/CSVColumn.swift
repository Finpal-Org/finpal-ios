//
//  CSVColumn.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/23/25.
//

import Foundation

struct CSVColumn<Record> {
    private(set) var header: String
    private(set) var attribute: (Record) -> CSVEncodable
    
    init(_ header: String, attribute: @escaping (Record) -> CSVEncodable) {
        self.header = header
        self.attribute = attribute
    }
}

extension CSVColumn {
    
    init<T: CSVEncodable>(_ header: String, _ keyPath: KeyPath<Record, T>) {
        self.init(header, attribute: { $0[keyPath: keyPath] })
    }
}
