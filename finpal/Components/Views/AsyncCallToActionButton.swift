//
//  AsyncCallToActionButton.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/6/25.
//

import SwiftUI

struct AsyncCallToActionButton: View {
    var isLoading: Bool = false
    var title: String = "Save"
    var action: () -> Void
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                Text(title)
            }
        }
        .callToActionButton()
        .anyButton(.press) {
            action()
        }
        .disabled(isLoading)
    }
}

private struct PreviewView: View {
    @State private var isLoading = false
    
    var body: some View {
        AsyncCallToActionButton(
            isLoading: isLoading,
            title: "Finish",
            action: {
                isLoading = true
                
                Task {
                    try? await Task.sleep(for: .seconds(3))
                    isLoading = false
                }
            }
        )
    }
}

#Preview {
    PreviewView()
}
