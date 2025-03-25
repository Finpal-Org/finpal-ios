//
//  VendorModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import Foundation

struct VendorModel: Codable {
    let name: String?
    let logoURL: String?
    
    init(name: String? = nil, logoURL: String? = nil) {
        self.name = name
        self.logoURL = logoURL
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case logoURL = "logo"
    }
    
    static var mock: Self {
        VendorModel(name: "Gourmet Coffee", logoURL: Constants.randomImageURL)
    }
}
