//
//  VeryfiLensView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/3/25.
//

import SwiftUI

struct VeryfiLensView: View {
    var lensManager = LensManager()
    
    @State private var lensEvents: [String] = []
    @State private var receipt: Receipt?
    @State private var lineItems: [LineItem] = []
    @State private var isReceiptScanFailed = false
    
    init() {
        lensManager.configure()
        lensManager.showCamera()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray5.ignoresSafeArea()
                
                if receipt != nil {
                    receiptView()
                } else {
                    loadingView
                }
            }
            .onAppear {
                lensManager.setDelegate(eventListener: eventListener)
            }
        }
    }
    
    @ViewBuilder
    private func receiptView() -> some View {
        if let receipt {
            ReceiptView(receiptData: receipt.data)
        } else {
            UtilityScanFailedView()
        }
    }
    
    func eventListener(_ json: [String: Any], _ decodedReceipt: Receipt?) -> Void {
        if let string = string(from: json) {
            lensEvents.append(string)
        }
        
        if let decodedReceipt = decodedReceipt {
            self.receipt = decodedReceipt
            self.lineItems = decodedReceipt.data.lineItems
            print("✅ Successfully decoded receipt with \(lineItems.count) items")
        } else {
            
        }
    }
    
    func string(from json: [String: Any]) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json as Any, options: .prettyPrinted) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    private var loadingView: some View {
        VStack(spacing: 24) {
            CircularLoaderView()
            
            Text("LOADING...")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(Color.brand60)
                .tracking(2)
        }
    }
}

#Preview {
    VeryfiLensView()
}
