//
//  Vendor.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import Foundation

struct Vendor: Codable {
    let logo: String
    let name: String
    
    enum CodingKeys: CodingKey {
        case logo
        case name
    }
    
    static var mock: Self {
        Vendor(logo: Constants.randomImageURL, name: "Gourmet Coffee")
    }
}
