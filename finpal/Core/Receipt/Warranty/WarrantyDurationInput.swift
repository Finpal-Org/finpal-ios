//
//  WarrantyDurationInput.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/22/25.
//

import SwiftUI

struct WarrantyDurationInput: View {
    @State private var warrantyDuration: Int = 1
    
    var body: some View {
        VStack(spacing: 24) {
            
            VStack(spacing: 12) {
                Text("Warranty Duration (in Months)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                
                HStack {
                    ZStack {
                        Circle()
                            .strokeBorder(Color.gray30, lineWidth: 1)
                        
                        Image(systemName: "minus")
                            .font(.system(size: 24, weight: .medium))
                    }
                    .frame(width: 48, height: 48)
                    .anyButton(.press) {
                        onDecrementButtonPressed()
                    }
                    
                    Text("\(warrantyDuration)")
                        .font(.system(size: 60, weight: .semibold))
                        .foregroundStyle(Color.brand60)
                        .frame(width: 215, height: 68)
                    
                    ZStack {
                        Circle()
                            .strokeBorder(Color.gray30, lineWidth: 1)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .medium))
                    }
                    .frame(width: 48, height: 48)
                    .anyButton(.press) {
                        onIncrementButtonPressed()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            }
            
            Text("Set the warranty duration in months.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.gray60)
        }
    }
    
    private func onIncrementButtonPressed() {
        warrantyDuration += 1
    }
    
    private func onDecrementButtonPressed() {
        warrantyDuration = max(warrantyDuration - 1, 1)
    }
    
}

#Preview {
    WarrantyDurationInput()
}
