//
//  TabBarView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/10/25.
//

import SwiftUI

enum TabSelection: String, Hashable {
    case home = "Home"
    case receipts = "Receipts"
    case veryfi = ""
    case chatbot = "Chatbot"
    case profile = "Profile"
    
    var systemName: String {
        switch self {
        case .home:
            return "house"
        case .receipts:
            return "receipt"
        case .chatbot:
            return "ellipsis.message"
        case .profile:
            return "person"
        default:
            return ""
        }
    }
}

struct TabBarView: View {
    @Environment(TabBarState.self) private var tabBar
    
    @State private var selectedTab = TabSelection.home
    @State private var navigateToChatbot = false
    
    var body: some View {
        if tabBar.showLens {
            VeryfiLensView(tabBar: tabBar)
        } else {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    TabView(selection: $selectedTab) {
                        switch selectedTab {
                        case .home:
                            HomeView()
                        case .receipts:
                            ReceiptsView()
                        case .veryfi:
                            EmptyView()
                        case .chatbot:
                            EmptyView()
                        case .profile:
                            ProfileView()
                        }
                    }
                    
                    HStack(spacing: 32) {
                        TabBarItem(selectedTab: $selectedTab, navigateToChatbot: $navigateToChatbot, tab: .home)
                        
                        TabBarItem(selectedTab: $selectedTab, navigateToChatbot: $navigateToChatbot, tab: .receipts)
                        
                        plusItemView
                        
                        TabBarItem(selectedTab: $selectedTab, navigateToChatbot: $navigateToChatbot, tab: .chatbot)
                        
                        TabBarItem(selectedTab: $selectedTab, navigateToChatbot: $navigateToChatbot, tab: .profile)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .border(width: 2, edges: [.top], color: Color.gray10)
                }
                .navigationDestination(isPresented: $navigateToChatbot) {
                    ChatbotChatView()
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
    
    private var plusItemView: some View {
        ZStack {
            Circle()
                .frame(width: 45, height: 45)
                .foregroundStyle(Color.gray10)
            
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundStyle(Color.gray80)
        }
        .padding(.top, 6)
        .onTapGesture {
            tabBar.showVeryfiLens()
        }
    }
}

struct TabBarItem: View {
    @Binding var selectedTab: TabSelection
    @Binding var navigateToChatbot: Bool
    
    var tab: TabSelection
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: tab.systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.gray60)
                .environment(\.symbolVariants, selectedTab == tab ? .fill : .none)
            
            Text(tab.rawValue)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.gray80)
        }
        .padding(.top, 12)
        .onTapGesture {
            if tab != .chatbot {
                selectedTab = tab
            } else {
                navigateToChatbot = true
            }
        }
    }
}

extension View {
    
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

#Preview {
    TabBarView()
        .previewEnvironment()
}
