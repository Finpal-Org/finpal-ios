//
//  DocumentModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import Foundation

struct DocumentModel: Codable {
    let data: ScannedReceiptModel
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
