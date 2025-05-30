//
//  VendorModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import Foundation

struct VendorModel: Hashable, Codable {
    let name: String?
    private(set) var logoURL: String?
    
    init(name: String? = nil, logoURL: String? = nil) {
        self.name = name
        self.logoURL = logoURL
    }
    
    mutating func updateLogoImage(imageName: String) {
        logoURL = imageName
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case logoURL = "logo"
    }
    
    static var mock: Self {
        VendorModel(name: "Gourmet Coffee", logoURL: Constants.randomImageURL)
    }
}
