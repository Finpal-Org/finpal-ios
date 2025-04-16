//
//  CategoryModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/18/25.
//

import Foundation

enum CategoryModel: String, Identifiable, CaseIterable {
    var id: Self { self }
    
    case meal = "Meal"
    case supplies = "Supplies"
    case hotel = "Hotel"
    case fuel = "Fuel"
    case transportation = "Transportation"
    case communication = "Communication"
    case subscriptions = "Suscriptions"
    case entertainment = "Entertainment"
    case training = "Training"
    case healthcare = "Healthcare"
    
    var iconName: String {
        switch self {
        case .meal:
            return "fork.knife"
        case .supplies:
            return "handbag"
        case .hotel:
            return "bed.double"
        case .fuel:
            return "fuelpump"
        case .transportation:
            return "car.side"
        case .communication:
            return "phone"
        case .subscriptions:
            return "banknote"
        case .entertainment:
            return "popcorn"
        case .training:
            return "dumbbell"
        case .healthcare:
            return "cross"
        }
    }
    
    static func stringToCategory(from string: String) -> CategoryModel? {
        return CategoryModel(rawValue: string)
    }
}
