//
//  VeryfiLensView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/3/25.
//

import SwiftUI

struct VeryfiLensView: View {
    private var lensManager = VeryfiLensManager()
    
    @State private var document: DocumentModel?
    
    @State private var isProcessing: Bool = true
    
    init() {
        lensManager.configure()
        lensManager.showCamera()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isProcessing {
                    loadingView
                }
                
                if let document {
                    ReceiptView(scannedReceipt: document.data)
                } else {
                    UtilityScanFailedView()
                        .opacity(isProcessing ? 0 : 1)
                }
            }
            .onAppear {
                lensManager.setDelegate(eventListener: eventListener)
            }
        }
    }
    
    func eventListener(_ document: DocumentModel?, _ isProcessing: Bool) -> Void {
        self.isProcessing = isProcessing
        self.document = document
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
