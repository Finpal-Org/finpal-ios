//
//  SelectSortOrderView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/26/25.
//

import SwiftUI

enum SortType: String, Identifiable, CaseIterable {
    var id: Self { self }
    
    case date = "Date"
    case total = "Total"
    case alphabeticallly = "A-Z"
    
    var systemNameIcon: String {
        switch self {
        case .date:
            return "calendar"
        case .total:
            return "dollarsign.square"
        case .alphabeticallly:
            return "a"
        }
    }
}

struct SelectSortOrderView: View {
    @Binding var sortType: SortType
    
    private let sortTypes = SortType.allCases
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: sortType.systemNameIcon)
                .frame(width: 20, height: 20)
                .font(.system(size: 18))
                .foregroundStyle(Color.brand60)
            
            Menu {
                ForEach(sortTypes) { type in
                    Button(type.rawValue, systemImage: type.systemNameIcon) {
                        sortType = type
                    }
                }
            } label: {
                HStack {
                    HStack(spacing: 0) {
                        Text("Sort By: ")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.gray80)
                        
                        Text(sortType.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.gray80)
                    }
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color.gray60)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var sortType = SortType.date
    SelectSortOrderView(sortType: $sortType)
}
