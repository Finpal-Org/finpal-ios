//
//  ReceiptAmountEditorView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/9/25.
//

import SwiftUI

fileprivate enum Tab: String, CaseIterable {
    case subtotal = "Subtotal"
    case tax = "VAT"
    case total = "Total"
}

struct ReceiptAmountEditorView: View {
    @State private var selectedTab: Tab?
    @State private var tabProgress: CGFloat = 0
    
    var body: some View {
        VStack {
            customTabBar()
            
            GeometryReader { geometry in
                let size = geometry.size
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        TransactionAmountInputView()
                            .id(Tab.subtotal)
                            .containerRelativeFrame(.horizontal)
                            .background(.red)
                        
                        TransactionAmountInputView()
                            .id(Tab.tax)
                            .containerRelativeFrame(.horizontal)
                            .background(.blue)
                        
                        TransactionAmountInputView()
                            .id(Tab.total)
                            .containerRelativeFrame(.horizontal)
                            .background(.green)
                    }
                    .scrollTargetLayout()
//                    .offsetX { value in
//                        let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
//                        tabProgress = await max(min(progress, 1), 0)
//                    }
                }
                .scrollPosition(id: $selectedTab)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.gray.opacity(0.1))
    }
    
    @ViewBuilder
    private func customTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Text(tab.rawValue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedTab = tab
                        }
                    }
            }
        }
        .background {
            GeometryReader { geometry in
                let size = geometry.size
                let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(.white)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    private func sampleView() -> some View {
        TransactionAmountInputView()
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
    }
}

private struct OffsetKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

extension View {
    
    func offsetX(completion: @escaping @Sendable (CGFloat) -> ()) -> some View {
        self.overlay {
            GeometryReader { geometry in
                let minX = geometry.frame(in: .scrollView(axis: .horizontal)).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
//                    .onPreferenceChange(OffsetKey.self, perform: completion)
            }
        }
    }
    
}

#Preview {
    ReceiptAmountEditorView()
}
