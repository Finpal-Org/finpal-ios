//
//  NoteSheetView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import SwiftUI

struct NoteSheetView: View {
    @Binding var noteText: String
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var text: String = ""
    @State private var characterLimit: Int = 300
    @State private var typedCharacters: Int = 0
    
    var body: some View {
        VStack(spacing: 24) {
            headerView
            textEditorView
            saveButtonView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray5)
    }
    
    private var headerView: some View {
        HStack {
            Text("Add Note")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.gray80)
            
            Spacer()
            
            Image(systemName: "xmark")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.gray60)
                .onTapGesture {
                    onXMarkButtonPressed()
                }
        }
        .padding(.horizontal, 16)
    }
    
    private var textEditorView: some View {
        TextEditor(text: $text)
            .frame(maxWidth: .infinity)
            .frame(height: 172)
            .limitText($text, to: 300)
            .font(.system(size: 16))
            .foregroundStyle(Color.gray60)
            .padding(12)
            .background(Color.white, in: .rect(cornerRadius: 24))
            .overlay {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.gray30, lineWidth: 1)
                    
                    HStack {
                        Text("\(typedCharacters)/\(characterLimit)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.gray40)
                        
                        Spacer()
                        
                        Image(systemName: "pencil.line")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.gray40)
                    }
                    .padding(12)
                }
            }
            .onChange(of: text) { _, _ in
                typedCharacters = text.count
                text = String(text.prefix(characterLimit))
            }
            .padding(16)
    }
    
    private var saveButtonView: some View {
        HStack {
            Text("Save Note")
            
            Image(systemName: "checkmark")
        }
        .callToActionButton()
        .anyButton(.press) {
            onSaveNoteButtonPressed()
        }
        .padding(.horizontal)
    }
    
    private func onSaveNoteButtonPressed() {
        noteText = text
        dismiss()
    }
    
    private func onXMarkButtonPressed() {
        dismiss()
    }
}

private struct PreviewView: View {
    @State private var noteText: String = ""
    @State private var isNoteSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            Button("Show Sheet") {
                isNoteSheetPresented.toggle()
            }
            
            Text("\(noteText.isEmpty ? "Not Set" : noteText)")
        }
        .sheet(isPresented: $isNoteSheetPresented) {
            NoteSheetView(noteText: $noteText)
                .presentationDetents([.fraction(0.6)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    PreviewView()
}
