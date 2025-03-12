//
//  OCRSettingsView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/8/25.
//

import SwiftUI

struct OCRSettingsView: View {
    var body: some View {
        ZStack {
            Color.gray5.ignoresSafeArea()
            
            VStack {
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("OCR Settings")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Color.gray80)
                    
                    Text("Adjust settings to optimize text recognition and enhance accuracy to fit your needs.")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.gray60)
                }
                
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .foregroundStyle(Color.white)
                        .overlay {
                            Toggle(isOn: .constant(false)) {
                                Text("Auto Capture")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color.gray80)
                            }
                            .tint(Color.accent)
                            .padding()
                        }
                        .padding()
                        .shadow(color: .black.opacity(0.03), radius: 1, y: 4)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    OCRSettingsView()
}
