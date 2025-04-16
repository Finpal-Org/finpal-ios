//
//  DocumentModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import Foundation

struct DocumentModel: Codable {
    let packageID: String
    let data: ReceiptModel
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case packageID = "package_id"
        case data
        case status
    }
}
