//
//  ReceiptsViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/26/25.
//

import SwiftUI
import Observation

@Observable class ReceiptsViewModel {
    var sortType = SortType.date
    var selectedCategories = Set<CategoryModel>()
    
    func sortedReceipts(myReceipts: [ReceiptModel]) -> [ReceiptModel] {
        let sortedReceipts = myReceipts
        
        switch sortType {
        case .date:
            return sortedReceipts.sorted { $0.date > $1.date }
        case .total:
            return sortedReceipts.sorted { $0.total > $1.total }
        case .alphabeticallly:
            return sortedReceipts.sorted {
                $0.vendor?.name?.localizedCaseInsensitiveCompare($1.vendor?.name ?? "") == .orderedAscending
            }
        }
    }
}
