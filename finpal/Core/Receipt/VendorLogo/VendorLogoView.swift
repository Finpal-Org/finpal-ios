//
//  VendorLogoView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/22/25.
//

import SwiftUI

struct VendorLogoView: View {
    @Binding var vendorLogo: UIImage?
    
    @State private var isVendorLogoSheetPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Vendor Logo")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.gray80)
                
                Spacer()
            }
            .padding(.horizontal)
            
            VStack(spacing: 16) {
                if let vendorLogo {
                    Image(uiImage: vendorLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .clipShape(.rect(cornerRadius: 24))
                } else {
                    missingLogoView
                }
                
                updateLogoButton
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .frame(height: 275)
            .background(Color.white, in: .rect(cornerRadius: 32))
            .padding(.horizontal)
            .mediumShadow()
        }
        .sheet(isPresented: $isVendorLogoSheetPresented) {
            VendorLogoSheetView(vendorLogo: $vendorLogo)
                .presentationDetents([.fraction(0.55)])
                .presentationDragIndicator(.visible)
        }
    }
    
    private var missingLogoView: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .foregroundStyle(Color.destructive5)
                    .frame(width: 40, height: 40)
                
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.destructive50)
            }
            
            VStack(spacing: 12) {
                Text("No Logo Detected")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.gray80)
                
                Text("No vendor or merchant logo detected in the scanned receipt. You can manually update the logo if needed.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.gray60)
            }
        }
    }
    
    private var updateLogoButton: some View {
        HStack {
            Image(systemName: "plus")
            
            Text("Update Logo")
        }
        .secondaryButton()
        .anyButton(.press) {
            onUpdateLogoButtonPressed()
        }
    }
    
    private func onUpdateLogoButtonPressed() {
        isVendorLogoSheetPresented = true
    }
}

#Preview {
    VendorLogoView(vendorLogo: .constant(nil))
}
