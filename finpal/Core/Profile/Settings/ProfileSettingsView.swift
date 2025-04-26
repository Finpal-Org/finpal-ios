//
//  ProfileSettingsView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/22/25.
//

import SwiftUI

struct ProfileSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 24) {
                    navigationBar
                    titleView
                }
                
                VStack(spacing: 24) {
                    changeBannerView
                    changeImageView
                }
                
                VStack(spacing: 24) {
                    fullNameForm
                    emailForm
                }
                
                saveButton
            }
            .padding(16)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray5)
    }
    
    private var navigationBar: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray80)
                .anyButton {
                    onBackButtonPressed()
                }
            
            Spacer()
        }
    }
    
    private var titleView: some View {
        Text("Profile Settings")
            .font(.system(size: 30, weight: .bold))
            .foregroundStyle(Color.gray80)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var changeBannerView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Profile Banner")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                
                Spacer()
                
                Text("Edit")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.brand60)
                    .anyButton {
                        
                    }
            }
            
            ZStack {
                Image(.profileHeader)
                    .resizable()
                    .scaledToFill()
                    .clipShape(.rect(cornerRadius: 24))
                    .padding(16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 220)
            .background(Color.white, in: .rect(cornerRadius: 24))
        }
        .mediumShadow()
    }
    
    private var changeImageView: some View {
        VStack {
            HStack {
                Text("Profile Image")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                
                Spacer()
                
                Text("Edit")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.brand60)
                    .anyButton {
                        
                    }
            }
            
            Image(.profileHeader)
                .resizable()
                .scaledToFill()
                .frame(width: 94, height: 94)
                .clipShape(.circle)
        }
    }
    
    private var fullNameForm: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Full Name")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            InputTextFieldView(
                "Enter your full name...",
                iconName: "person",
                keyboardType: .alphabet,
                error: nil,
                text: $fullName
            )
        }
    }
    
    private var emailForm: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email Address")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray80)
            
            InputTextFieldView(
                "Enter your email address...",
                iconName: "envelope",
                keyboardType: .alphabet,
                error: nil,
                text: $email
            )
        }
    }
    
    private var saveButton: some View {
        HStack {
            Text("Save Settings")
            
            Image(systemName: "checkmark")
        }
        .callToActionButton()
        .anyButton(.press) {
            
        }
    }
    
    private func onBackButtonPressed() {
        dismiss()
    }
    
}

#Preview {
    ProfileSettingsView()
}
