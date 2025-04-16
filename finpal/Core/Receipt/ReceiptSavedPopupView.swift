//
//  ReceiptSavedPopupView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/15/25.
//

import SwiftUI
import PopupView
import ConfettiSwiftUI

struct ReceiptSavedPopupView: View {
    @Binding var isPresented: Bool
    
    private var error: Binding<Bool>
    private var result: Binding<Bool>
    
    @State private var isFailed = false
    @State private var showView = false
    
    @State private var drawRing = 1 / 99
    @State private var showCircle = 0
    
    @State private var rotateSymbol = 30
    @State private var showSymbol = -60
    
    @State private var triggerConfetti = false
    
    init(isPresented: Binding<Bool>, error: Binding<Bool>, result: Binding<Bool>) {
        self._isPresented = isPresented
        self.error = error
        self.result = result
    }
    
    var body: some View {
        VStack(spacing: 24) {
            navigationBarView
            
            Spacer()
            
            if showView {
                if error.wrappedValue {
                    saveFailedView
                        .transition(.move(edge: .trailing))
                } else {
                    saveSuccessView
                        .transition(.move(edge: .trailing))
                }
            } else {
                loadingView
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 400)
        .padding(.horizontal, 16)
        .background(Color.white.cornerRadius(20))
        .shadow(color: .black.opacity(0.3), radius: 1)
        .padding(.horizontal, 40)
        .confettiCannon(trigger: $triggerConfetti, num: 40)
        .onChange(of: result.wrappedValue) { oldValue, newValue in
            if newValue {
                onToggleButtonPressed()
            }
        }
    }
    
    private var navigationBarView: some View {
        HStack {
            Spacer()
            
            Image(systemName: "xmark")
                .font(.system(size: 20))
                .foregroundStyle(Color.gray60)
        }
        .padding(.top, 16)
        .onTapGesture {
            onXMarkButtonPressed()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 24) {
            ZStack {
                CircularLoaderView()
                    .opacity(drawRing == 1 ? 0 : 1)
                    .animation(.easeOut(duration: 0.6).delay(1.1), value: drawRing)
                
                if isFailed {
                    failureAnimation
                } else {
                    successAnimation
                }
            }
            
            Text("SAVING...")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(Color.brand60)
                .tracking(2)
                .opacity(drawRing == 1 ? 0 : 1)
                .animation(.easeOut(duration: 0.6).delay(1.1), value: drawRing)
        }
    }
    
    private var successAnimation: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(drawRing))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .frame(width: 64)
                .rotationEffect(.degrees(-90))
                .foregroundStyle(Color.brand60)
                .animation(.easeInOut(duration: 1).delay(1), value: drawRing)
            
            Circle()
                .frame(width: 74)
                .foregroundStyle(Color.brand60)
                .scaleEffect(CGFloat(showCircle))
                .animation(.interpolatingSpring(stiffness: 170, damping: 15).delay(2), value: showCircle)
            
            Image(systemName: "checkmark")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(Double(rotateSymbol)))
                .clipShape(.rect.offset(x: CGFloat(showSymbol)))
                .animation(.interpolatingSpring(stiffness: 170, damping: 15).delay(2.5), value: showSymbol)
        }
    }
    
    private var failureAnimation: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(drawRing))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .frame(width: 64)
                .rotationEffect(.degrees(-90))
                .foregroundStyle(Color.destructive60)
                .animation(.easeInOut(duration: 1).delay(1), value: drawRing)
            
            Circle()
                .frame(width: 74)
                .foregroundStyle(Color.destructive60)
                .scaleEffect(CGFloat(showCircle))
                .animation(.interpolatingSpring(stiffness: 170, damping: 15).delay(2), value: showCircle)
            
            Image(systemName: "xmark")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(Double(rotateSymbol)))
                .clipShape(.rect.offset(x: CGFloat(showSymbol)))
                .animation(.interpolatingSpring(stiffness: 170, damping: 15).delay(2.5), value: showSymbol)
        }
    }
    
    private var saveSuccessView: some View {
        VStack {
            Image(.receiptSaveSuccess)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 12) {
                Text("Receipt Saved!")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                
                Text("Great job! Remember, you can edit everything later on.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.gray60)
            }
            
            Spacer()
        }
        .onAppear {
            triggerConfetti.toggle()
        }
    }
    
    private var saveFailedView: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 74)
                    .foregroundStyle(Color.destructive60)
                
                Image(systemName: "xmark")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.white)
                
            }
            
            VStack(spacing: 12) {
                Text("Failed to Save")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(Color.gray80)
                
                Text("Your receipt has not been saved!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.gray60)
            }
        }
        .padding()
    }
    
    private func onXMarkButtonPressed() {
        isPresented = false
    }
    
    private func onToggleButtonPressed() {
        Task {
            drawRing = 1
            showCircle = 1
            rotateSymbol = 0
            showSymbol = 0
            
            try? await Task.sleep(for: .seconds(4))
            
            withAnimation(.bouncy) {
                showView.toggle()
            }
        }
    }
    
}

extension View {
    
    func savePopup(isPresented: Binding<Bool>, error: Binding<Bool>, result: Binding<Bool>) -> some View {
        self
            .popup(isPresented: isPresented) {
                ReceiptSavedPopupView(isPresented: isPresented, error: error, result: result)
            } customize: { parameters in
                parameters
                    .type(.default)
                    .position(.center)
                    .closeOnTap(false)
            }
    }
}

private struct PreviewView: View {
    @State private var showPopup = false
    @State private var showError = false
    @State private var showResult = false
    
    var body: some View {
        VStack {
            Button("Show Popup") {
                onButtonPressed()
            }
        }
        .savePopup(isPresented: $showPopup, error: $showError, result: $showResult)
    }
    
    private func onButtonPressed() {
        showPopup.toggle()
        
        Task {
            do {
                try await Task.sleep(for: .seconds(4))
                showResult.toggle()
            } catch {
                
            }
        }
    }
    
}

#Preview {
    PreviewView()
}
