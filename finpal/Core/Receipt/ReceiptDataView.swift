//
//  ReceiptDataView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/11/25.
//

import SwiftUI

struct ReceiptDataView: View {
    @ObservedObject var viewModel: ScannedReceiptViewModel
    
    var body: some View {
        VStack {
            headerView
            invoiceNumberView
            orderItemsListView
            orderSummaryView
            
            Text("")
        }
        .background(Color.white)
        .mask {
            ZigZagTop(depth: 20)
        }
        .mask {
            ZigZagBottom(depth: 20)
        }
        .padding()
        .shadow(color: .black.opacity(0.09), radius: 8, x: 0, y: 4)
        .mediumShadow()
    }
    
    private var headerView: some View {
        VStack(spacing: 24) {
            ImageLoaderView(urlString: viewModel.vendorImage)
                .frame(width: 75, height: 75)
                .padding(.top, 32)
                .offset(y: 15)
            
            VStack(spacing: 8) {
                Text(viewModel.vendorName ?? "Not Set")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.gray80)
                    .multilineTextAlignment(.center)
                
                Text(formattedDateWithBullet(date: viewModel.date))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.gray80)
            }
            .padding()
        }
    }
    
    private var invoiceNumberView: some View {
        VStack {
            Line()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 1)
                .padding(.vertical)
                .foregroundStyle(Color.gray40)
            
            Rectangle()
                .stroke(Color.gray60, lineWidth: 3)
                .frame(width: 200, height: 75)
                .overlay {
                    Text("#\(viewModel.invoiceNumber ?? "")")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray60)
                }
            
            Line()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 1)
                .padding(.vertical)
                .foregroundStyle(Color.gray40)
        }
    }
    
    private var orderItemsListView: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.lineItems) { item in
                receiptItem(
                    quantity: item.quantity,
                    name: item.description,
                    price: item.total
                )
                
                Divider()
                    .padding(.horizontal)
            }
        }
    }
    
    private func receiptItem(quantity: Int, name: String, price: Double) -> some View {
        HStack(spacing: 24) {
            Text("\(quantity)x")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(Color.gray60)
            
            Text(name)
                .font(.title3)
                .foregroundStyle(Color.gray80)
            
            Spacer()
            
            Text(getPriceString(for: price))
        }
        .padding(.horizontal)
    }
    
    private var orderSummaryView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Subtotal")
                
                Spacer()
                
                Text(getPriceString(for: viewModel.subtotal))
            }
            .font(.title3)
            .foregroundStyle(Color.gray80)
            
            HStack {
                Text("VAT (15%)")
                
                Spacer()
                
                Text(getPriceString(for: viewModel.tax))
            }
            .font(.title3)
            .foregroundStyle(Color.gray80)
            
            HStack {
                Text("Total Bill")
                
                Spacer()
                
                Text(getPriceString(for: viewModel.total))
            }
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(Color.gray80)
        }
        .padding()
    }
    
    private func getPriceString(for value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.currencyCode = "SAR"
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    private func formattedDateWithBullet(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateString = dateFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        let timeString = timeFormatter.string(from: date)
        
        return "\(dateString) • \(timeString)"
    }
    
}

fileprivate struct Line: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

#Preview {
    ReceiptDataView(viewModel: ScannedReceiptViewModel(receipt: .mock))
}
