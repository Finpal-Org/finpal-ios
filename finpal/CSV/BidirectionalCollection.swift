//
//  BidirectionalCollection.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/24/25.
//

import Foundation

internal extension BidirectionalCollection where Element == String {
    var commaDelimited: String { joined(separator: ",") }
    var newlineDelimited: String { joined(separator: "\r\n") }
}
