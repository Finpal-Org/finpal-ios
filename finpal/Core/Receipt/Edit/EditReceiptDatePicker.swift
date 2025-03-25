//
//  EditReceiptDatePicker.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/15/25.
//

import SwiftUI

struct EditReceiptDatePicker: View {
    let iconName: String
    
    @Binding var date: Date
    @Binding var showDatePicker: Bool
    
    var body: some View {
        HStack {
            Text(date.toString("MMM d, yyyy"))
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
            
            Text("•")
            
            Text(date.toString("hh:mm a"))
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray60)
            
            Spacer()
            
            Image(systemName: "calendar")
                .imageScale(.large)
                .fontWeight(.semibold)
                .foregroundStyle(Color.gray60)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(
            Capsule()
                .stroke(Color.gray30, lineWidth: 1)
                .fill(Color.white)
        )
        .onTapGesture {
            showDatePicker.toggle()
        }
        .sheet(isPresented: $showDatePicker) {
            SheetDatePicker(date: $date)
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
        }
        .padding(.horizontal)
    }
}

private struct PreviewView: View {
    @State private var currentDate: Date = .now
    @State private var showDatePicker: Bool = false
    
    var body: some View {
        EditReceiptDatePicker(iconName: "calendar", date: $currentDate, showDatePicker: $showDatePicker)
    }
}

#Preview {
    PreviewView()
}
