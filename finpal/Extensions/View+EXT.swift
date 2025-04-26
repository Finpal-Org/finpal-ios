//
//  View+EXT.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/6/25.
//

import SwiftUI

extension View {
    
    func callToActionButton() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(.accent)
            .clipShape(.capsule)
    }
    
    func secondaryButton(backgroundColor: Color = .white) -> some View {
        self
            .font(.headline)
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(backgroundColor)
            .clipShape(.capsule)
            .overlay {
                Capsule()
                    .stroke(.accent, lineWidth: 1.0)
            }
    }
    
    func removeListRowFormatting() -> some View {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
    }
    
    func placeholder<Content: View>(when shouldShow: Bool, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: .leading) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    @ViewBuilder
    func ifSatisfiedCondition(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func mediumShadow() -> some View {
        self
            .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
            .shadow(color: .black.opacity(0.02), radius: 16, x: 0, y: 8)
    }
    
    func limitText(_ text: Binding<String>, to characterLimit: Int) -> some View {
        self
            .onChange(of: text.wrappedValue) { _, _ in
                text.wrappedValue = String(text.wrappedValue.prefix(characterLimit))
            }
    }
    
    func withRouter() -> some View {
        modifier(RouterViewModifier())
    }
    
    func signOutAlert(isPresented: Binding<Bool>, onConfirm: @escaping () -> Void) -> some View {
        alert(
            "Are you sure you want to sign out?",
            isPresented: isPresented,
            actions: {
                Button("Cancel", role: .cancel) {
                    
                }
                
                Button("Sign Out", role: .destructive) {
                    onConfirm()
                }
            },
            message: {
                Text("You will be signed out of your account. Any unsaved changes may be lost.")
            }
        )
    }
    
    func deleteAlert(isPresented: Binding<Bool>, deleteText: Binding<String>, onConfirm: @escaping () -> Void) -> some View {
        alert(
            "Are you sure you want to delete your account?",
            isPresented: isPresented,
            actions: {
                TextField("DELETE", text: deleteText)
                
                Button("Cancel", role: .cancel) {
                    
                }
                
                Button("Delete", role: .destructive) {
                    if deleteText.wrappedValue == "DELETE" {
                        onConfirm()
                    }
                }
            },
            message: {
                Text("This action is permanent and cannot be undone. To confirm, please type DELETE in the field below.")
            }
        )
    }
    
}
