//
//  VendorLogoSheetView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/21/25.
//

import SwiftUI
import PhotosUI

struct VendorLogoSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var vendorLogo: UIImage?
    
    @State private var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showingError: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            toolbarView
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(.rect(cornerRadius: 16))
                    .overlay(alignment: .topLeading) {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.destructive60)
                            .padding(8)
                            .onTapGesture {
                                onDeleteImageButtonPressed()
                            }
                    }
            } else {
                browseFileButton
            }
            
            saveLogoButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray5)
    }
    
    private var toolbarView: some View {
        HStack {
            Text("Change Vendor Logo")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Spacer()
            
            Image(systemName: "xmark")
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(Color.gray60)
                .onTapGesture {
                    onXMarkButtonPressed()
                }
        }
        .padding(.horizontal)
    }
    
    private var browseFileButton: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Browse your file to upload")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.brand60)
                
                Text("Supported Format: SVG, JPG, PNG (10mb each)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.gray40)
            }
            
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                HStack(spacing: 8) {
                    Text("Browse File")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Image(systemName: "tray.and.arrow.up")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 136, height: 40)
            .background(Color.brand60, in: .capsule)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 142)
        .background {
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.white)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .strokeBorder(Color.gray30, style: StrokeStyle(lineWidth: 1, dash: [6]))
        }
        .padding()
        .onChange(of: photosPickerItem) { _, _ in
            Task {
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
                
                photosPickerItem = nil
                showingError = false
            }
        }
    }
    
    private var saveLogoButton: some View {
        VStack(spacing: 16) {
            if showingError {
                ErrorBoxView("Upload a logo file before saving!")
            }
            
            HStack {
                Text("Save Logo")
                
                Image(systemName: "checkmark")
            }
            .callToActionButton()
            .anyButton(.press) {
                onSaveLogoButtonPressed()
            }
        }
        .padding(.horizontal)
        .animation(.easeInOut, value: showingError)
    }
    
    private func onDeleteImageButtonPressed() {
        selectedImage = nil
    }
    
    private func onSaveLogoButtonPressed() {
        if let selectedImage {
            vendorLogo = selectedImage
            dismiss()
        } else {
            showingError = true
        }
    }
    
    private func onXMarkButtonPressed() {
        dismiss()
    }
}

#Preview {
    VendorLogoSheetView(vendorLogo: .constant(.profileHeader))
}
