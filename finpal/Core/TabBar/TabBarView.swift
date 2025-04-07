//
//  TabBarView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/10/25.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var viewRouter: TabBarViewRouter
    
    @State private var showPopUp = false
    @State private var showLens: Bool = false
    
    var body: some View {
        if showLens {
            VeryfiLensView()
        } else {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    switch viewRouter.currentPage {
                    case .home:
                        Text("Home")
                    case .receipts:
                        Text("Receipts")
                    case .chatbot:
                        Text("Chatbot")
                    case .profile:
                        ProfileView()
                    }
                    
                    Spacer()
                    
                    ZStack {
                        if showPopUp {
                            PlusMenu(widthAndHeight: geometry.size.width / 7, showLens: $showLens)
                                .offset(y: -geometry.size.height / 6)
                        }
                        
                        HStack {
                            // Home
                            TabBarIcon(
                                viewRouter: viewRouter,
                                assignedPage: .home,
                                size: geometry.size,
                                systemIconName: "house",
                                tabName: "Home"
                            )
                            
                            // Receipts
                            TabBarIcon(
                                viewRouter: viewRouter,
                                assignedPage: .receipts,
                                size: geometry.size,
                                systemIconName: "receipt",
                                tabName: "Receipts"
                            )
                            
                            ZStack {
                                Circle()
                                    .foregroundStyle(.white)
                                    .frame(width: geometry.size.width / 7, height: geometry.size.width / 7)
                                    .shadow(radius: 4)
                                
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width / 7 - 6, height: geometry.size.height / 7 - 6)
                                    .foregroundStyle(.accent)
                                    .rotationEffect(Angle(degrees: showPopUp ? 90 : 0))
                            }
                            .offset(y: -geometry.size.height / 8 / 2)
                            .onTapGesture {
                                withAnimation {
                                    showPopUp.toggle()
                                }
                            }
                            
                            // Chatbot
                            TabBarIcon(
                                viewRouter: viewRouter,
                                assignedPage: .chatbot,
                                size: geometry.size,
                                systemIconName: "message",
                                tabName: "Chat"
                            )
                            
                            // Profile
                            TabBarIcon(
                                viewRouter: viewRouter,
                                assignedPage: .profile,
                                size: geometry.size,
                                systemIconName: "person",
                                tabName: "Profile"
                            )
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height / 8)
                        .background(Color(uiColor: .secondarySystemBackground).shadow(radius: 2))
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

struct PlusMenu: View {
    let widthAndHeight: CGFloat
    
    @Binding var showLens: Bool
    
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .foregroundStyle(.accent)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .shadow(radius: 4)
                
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundStyle(.white)
            }
            .onTapGesture {
                showLens = true
            }
            
            ZStack {
                Circle()
                    .foregroundStyle(.accent)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .shadow(radius: 4)
                
                Image(systemName: "photo.fill.on.rectangle.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundStyle(.white)
            }
        }
        .transition(.scale)
    }
}

#Preview {
    TabBarView(viewRouter: TabBarViewRouter())
        .environment(AppState())
}

struct TabBarIcon: View {
    @StateObject var viewRouter: TabBarViewRouter
    let assignedPage: Page
    
    let size: CGSize
    let systemIconName: String
    let tabName: String
    
    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .scaledToFit()
                .frame(width: size.width / 5, height: size.height / 28)
                .padding(.top, 10)
            
            Text(tabName)
                .font(.footnote)
            
            Spacer()
        }
        .padding(.horizontal, -4)
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
        .foregroundStyle(viewRouter.currentPage == assignedPage ? .accent : .gray)
    }
}
