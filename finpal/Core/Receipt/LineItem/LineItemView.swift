//
//  LineItemView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import SwiftUI

struct LineItemView: View {
    @Binding var lineItems: [LineItemModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(spacing: 6) {
                Image(systemName: "receipt")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.gray60)
                
                Text("Items")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.gray80)
            }
            .padding([.horizontal, .top])
            
            Text("Swipe left to delete an item.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.gray60)
                .padding([.horizontal, .bottom])
            
            if lineItems.isEmpty {
                Text("No items added yet.")
                    .font(.callout)
                    .foregroundStyle(Color.gray60)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                lineItemsHeader
                
                ScrollView(.vertical) {
                    LazyVStack(spacing: 12) {
                        ForEach(lineItems) { item in
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
    
    private func swipeItem(item: LineItemModel) -> some View {
        SwipeItem(
            content: {
                LineItemInputView(
                    quantity: $lineItems[getIndex(item: item)].quantity,
                    name: $lineItems[getIndex(item: item)].description,
                    price: $lineItems[getIndex(item: item)].total
                )
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
    }
    
    private func onDeleteButtonPressed(item: LineItemModel) {
        lineItems.removeAll { (item1) -> Bool in
            return item.id == item1.id
        }
    }
    
    private func getIndex(item: LineItemModel) -> Int {
        return lineItems.firstIndex(where: { $0.id == item.id }) ?? 0
    }
}

private struct PreviewView: View {
    @State private var items: [LineItemModel] = []
    
    var body: some View {
        VStack {
            LineItemView(lineItems: $items)
        }
        .onAppear {
            self.items = LineItemModel.mocks
        }
    }
}

#Preview {
    PreviewView()
}
