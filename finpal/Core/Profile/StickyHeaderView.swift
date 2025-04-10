//
//  StickyHeaderView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/8/25.
//

import SwiftUI

struct StickyHeaderView: View {
    let currentUser: UserModel?
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let minY = geometry.frame(in: .global).minY
            let isScrolling = minY > 0
            
            VStack {
                Image(.profileHeader)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: isScrolling ? 215 + minY : 215)
                    .clipped()
                    .offset(y: isScrolling ? -minY : 0)
                    .blur(radius: isScrolling ? 0 + minY / 80 : 0)
                    .scaleEffect(isScrolling ? 1 + minY / 2000 : 1)
                    .overlay(alignment: .bottom) {
                        ZStack {
                            profileImageView()
                        }
                        .frame(width: 96, height: 96)
                        .clipShape(.circle)
                        .offset(y: 50)
                        .offset(y: isScrolling ? -minY : 0)
                    }
                
                Group {
                    VStack(spacing: 8) {
                        Text("Member since \(formattedDate)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.gray60)
                        
                        Text(currentUser?.fullName ?? "")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color.gray80)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width)
                            .lineLimit(2)
                            .fixedSize()
                    }
                    .offset(y: isScrolling ? -minY : 0)
                }
                .padding(.vertical, 60)
            }
        }
        .frame(height: 385)
    }
    
    @ViewBuilder
    private func profileImageView() -> some View {
        if let currentUser {
            
            if let imageName = currentUser.profileImageURL {
                userProfileImageView(imageName: imageName)
            } else {
                placeholderProfileImageView
            }
            
        } else {
            placeholderProfileImageView
        }
    }
    
    private func userProfileImageView(imageName: String) -> some View {
        ZStack {
            ImageLoaderView(urlString: imageName)
                .scaledToFill()
            
            Circle()
                .stroke(Color.white, lineWidth: 6)
        }
    }
    
    private var placeholderProfileImageView: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color.gray10)
            
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .foregroundStyle(Color.brand60)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        if let creationDate = currentUser?.creationDate {
            return formatter.string(from: creationDate)
        } else {
            return formatter.string(from: .now)
        }
    }
}

private struct PreviewView: View {
    var body: some View {
        ScrollView {
            VStack {
                StickyHeaderView(currentUser: .mock)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PreviewView()
}
