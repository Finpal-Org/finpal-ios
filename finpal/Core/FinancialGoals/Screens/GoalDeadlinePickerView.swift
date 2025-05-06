//
//  GoalDeadlinePickerView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/6/25.
//

import SwiftUI

struct GoalDeadlinePickerView: View {
    @Binding var page: Int
    
    @State private var date = Date()
    
    var body: some View {
        VStack {
            Text("When do you need this by?")
                .multilineTextAlignment(.leading)
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color.gray80)
                .tracking(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack {
                DatePicker(
                    "",
                    selection: $date,
                    in: Date.now...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.gray40)
                    
                    Text(timeFromNowString(to: date))
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.gray60)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12) {
                HStack {
                    Text("Continue")
                    
                    Image(systemName: "arrow.right")
                }
                .callToActionButton()
                .frame(width: 142)
                .anyButton(.press) {
                    page += 1
                }
                
                HStack {
                    Image(systemName: "chevron.left")
                    
                    Text("No, Go Back")
                }
                .secondaryButton()
                .frame(width: 162)
                .anyButton(.press) {
                    page -= 1
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
    }
    
    func timeFromNowString(to date: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        
        // Get year and day difference
        let components = calendar.dateComponents([.year, .day], from: now, to: date)
        
        let years = components.year ?? 0
        let days = (components.day ?? 0) % 365 // approximate leftover days
        
        // Build string
        var parts: [String] = []
        
        if years > 0 {
            parts.append("\(years) year\(years > 1 ? "s" : "")")
        }
        
        if days > 0 {
            parts.append("\(days) day\(days > 1 ? "s" : "")")
        }
        
        if parts.isEmpty {
            return "Today"
        }
        
        return parts.joined(separator: " and ") + " from now."
    }
    
}

#Preview {
    GoalDeadlinePickerView(page: .constant(4))
}
