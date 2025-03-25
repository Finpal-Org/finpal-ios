//
//  LineItemView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import SwiftUI

struct LineItemView: View {
    @StateObject private var viewModel: LineItemViewModel
    
    init(viewModel: LineItemViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Items")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.gray80)
                .padding([.horizontal, .top])
            
            Text("Swipe left to delete an item.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.gray60)
                .padding([.horizontal, .bottom])
            
            if viewModel.items.isEmpty {
                Text("No items added yet.")
                    .font(.callout)
                    .foregroundStyle(Color.gray60)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                lineItemsHeader
                
                ScrollView(.vertical) {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.items) { item in
                            swipeItem(item: item)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
    
    private var lineItemsHeader: some View {
        HStack {
            Text("QTY")
                .padding(.leading, 22)
            
            Text("DESC")
                .padding(.leading, 24)
            
            Spacer()
            
            Text("AMT")
                .padding(.trailing, 45)
        }
        .font(.system(size: 13, weight: .regular))
        .foregroundStyle(Color.gray40)
    }
    
    private var paymentSummary: some View {
        VStack {
            Text(viewModel.calculateSubtotal())
                .font(.title)
            
            Text(viewModel.calculateTax())
                .font(.title)
            
            Text(viewModel.calculateTotalPrice())
                .font(.title)
        }
    }
    
    private func swipeItem(item: LineItemModel) -> some View {
        SwipeItem(
            content: {
                ItemView(item: $viewModel.items[getIndex(item: item)])
            },
            left: {
                ZStack {
                    
                }
            },
            right: {
                ZStack {
                    Capsule()
                        .fill(Color.destructive60)
                    
                    Image(systemName: "trash.circle")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
                .onTapGesture {
                    onDeleteButtonPressed(item: item)
                }
            },
            itemHeight: 50
        )
        .frame(height: 50)
        .transition(.move(edge: .trailing))
    }
    
    private func onDeleteButtonPressed(item: LineItemModel) {
        viewModel.items.removeAll { (item1) -> Bool in
            return item.id == item1.id
        }
    }
    
    func getIndex(item: LineItemModel) -> Int {
        return viewModel.items.firstIndex(where: { $0.id == item.id }) ?? 0
    }
}

#Preview {
    LineItemView(viewModel: LineItemViewModel(items: LineItemModel.mocks))
}
