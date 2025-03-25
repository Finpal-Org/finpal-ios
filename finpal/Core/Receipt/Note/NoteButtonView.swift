//
//  NoteButtonView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/19/25.
//

import SwiftUI

struct NoteButtonView: View {
    @Binding var noteText: String
    
    @State private var isNoteSheetPresented: Bool = false
    
    var body: some View {
        Button {
            isNoteSheetPresented = true
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .foregroundStyle(Color.white)
                .overlay {
                    HStack(spacing: 8) {
                        // Note Icon
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color.gray5)
                            
                            Image(systemName: "note.text")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.gray60)
                        }
                        
                        // Note Title
                        Text("Note")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.gray80)
                        
                        Spacer()
                        
                        // Note
                        Text("\(noteText.isEmpty ? "Not Set" : noteText)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.gray80)
                        
                        // Chevron
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.gray60)
                    }
                    .padding()
                }
                .padding(.horizontal)
        }
        .mediumShadow()
        .sheet(isPresented: $isNoteSheetPresented) {
            NoteSheetView(noteText: $noteText)
                .presentationDetents([.fraction(0.6)])
                .presentationDragIndicator(.visible)
        }
    }
    
    private func onAddNoteButtonPressed() {
        isNoteSheetPresented = true
    }
}

#Preview {
    @Previewable @State var noteText: String = ""
    
    NoteButtonView(noteText: $noteText)
}
