//
//  LineItemViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import Foundation

class LineItemViewModel: ObservableObject {
    @Published var items: [LineItemModel]
    
    private let taxRate: Double = 0.15
    
    init(items: [LineItemModel] = LineItemModel.mocks) {
        self.items = items
    }
    
    func addItem() {
        let randomNumber = Int.random(in: 1_000_000_000...9_999_999_999)
        
        let newItem = LineItemModel(
            id: randomNumber,
            quantity: 1,
            description: "Item Name",
            total: 0.00
        )
        
        items.append(newItem)
    }
    
    func calculateSubtotal() -> String {
        var subtotal: Float = 0
        
        items.forEach { item in
            subtotal += Float(item.quantity) * Float(item.total)
        }
        
        return getPrice(value: subtotal)
    }
    
    func calculateTax() -> String {
        var subtotal: Float = 0
        
        items.forEach { item in
            subtotal += Float(item.quantity) * Float(item.total)
        }
        
        let tax = subtotal * Float(taxRate)
        
        return getPrice(value: tax)
    }
    
    func calculateTotalPrice() -> String {
        var subtotal: Float = 0
        
        items.forEach { item in
            subtotal += Float(item.quantity) * Float(item.total)
        }
        
        let tax = subtotal * Float(taxRate)
        let total = subtotal + tax
        
        return getPrice(value: total)
    }
    
    private func getPrice(value: Float) -> String {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format.string(from: NSNumber(value: value)) ?? ""
    }
}
