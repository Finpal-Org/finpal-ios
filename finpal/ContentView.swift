//
//  ContentView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/6/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Client ID: \(KeysConfiguration.clientId)")
                .padding()
            
            Text("Auth Username: \(KeysConfiguration.authUsername)")
                .padding()
            
            Text("Auth API Key: \(KeysConfiguration.authApiKey)")
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
