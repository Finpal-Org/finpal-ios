//
//  ErrorPopupView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/5/25.
//

import SwiftUI
import PopupView

struct ErrorPopupView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.destructive60)
            
            Text(message)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.destructive5, in: .rect(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.destructive60, lineWidth: 1)
        }
        .padding(EdgeInsets(top: 75, leading: 32, bottom: 16, trailing: 32))
    }
}

extension View {
    
    func errorPopup(showingPopup: Binding<Bool>, _ message: String, action: (() -> ())? = nil) -> some View {
        self
            .popup(isPresented: showingPopup) {
                ErrorPopupView(message: message)
            } customize: { parameters in
                parameters
                    .type(.toast)
                    .autohideIn(4)
                    .dragToDismiss(true)
                    .position(.top)
                    .dismissCallback {
                        if let action {
                            action()
                        }
                    }
            }
    }
}

private struct PreviewView: View {
    @State private var showPopup: Bool = false
    
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            Button("Show Error Popup") {
                showPopup.toggle()
            }
            
        }
        .errorPopup(showingPopup: $showPopup, "Test Error Message") {
            print("Disappeared...")
        }
    }
}

#Preview {
    PreviewView()
}
