//
//  SheetDatePicker.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/15/25.
//

import SwiftUI

struct SheetDatePicker: View {
    @Binding var date: Date
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentDate: Date = .now
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Set Date")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.gray80)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.gray60)
                    .onTapGesture {
                        onXMarkButtonPressed()
                    }
            }
            
            DatePicker(
                "",
                selection: $currentDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            
            HStack {
                Text("Time")
                    .font(.callout)
                    .fontWeight(.bold)
                
                Spacer()
                
                Capsule()
                    .stroke(Color.gray30, lineWidth: 1)
                    .frame(width: 108, height: 32)
                    .overlay {
                        HStack(spacing: 8) {
                            Text(currentDate.toString("hh:mm a"))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.gray60)
                            
                            Image(systemName: "chevron.down")
                                .imageScale(.small)
                                .foregroundStyle(Color.gray60)
                        }
                    }
                    .overlay {
                        DatePicker("", selection: $currentDate, displayedComponents: [.hourAndMinute])
                            .blendMode(.destinationOver)
                    }
            }
            
            HStack {
                Text("Set Date")
                
                Image(systemName: "checkmark")
            }
            .callToActionButton()
            .anyButton(.press) {
                onSetDateButtonPressed()
            }
        }
        .padding()
    }
    
    private func onSetDateButtonPressed() {
        date = currentDate
        dismiss()
    }
    
    private func onXMarkButtonPressed() {
        dismiss()
    }
}

private struct PreviewView: View {
    @State private var selectedDate: Date = .now
    
    var body: some View {
        SheetDatePicker(date: $selectedDate)
    }
}

#Preview {
    PreviewView()
}
