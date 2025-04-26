//
//  VeryfiLensView.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/3/25.
//

import SwiftUI

extension Notification.Name {
    static let VeryfiLensAnalyticsEvent = Notification.Name("VeryfiLensAnalyticsEvent")
}

struct VeryfiLensView: View {
    @Bindable var tabBarState: TabBarState
    
    private var lensManager: VeryfiLensManager
    
    @State private var document: DocumentModel?
    
    @State private var isProcessing: Bool = true
    
    @State private var isDocumentDetected = false
//    lens_submit_document_detection_status
    
    init(tabBar: TabBarState) {
        self._tabBarState = Bindable(tabBar)
        self.lensManager = VeryfiLensManager(tabBarState: tabBar)
        
        lensManager.configure()
        lensManager.showCamera()
    }
    
//    init(tabBarState: TabBarState) {
//        self.tabBarState = tabBarState
//        self.lensManager = VeryfiLensManager(tabBarState: tabBarState)
//        
//        lensManager.configure()
//        lensManager.showCamera()
//    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isProcessing {
                    loadingView
                }
                
                if let document {
                    ReceiptView(scannedReceipt: document.data)
                } else {
                    UtilityScanFailedView()
                        .opacity(isProcessing ? 0 : 1)
                }
            }
            .onAppear {
                lensManager.setDelegate(eventListener: eventListener)
            }
            .onDisappear {
                lensManager.removeDelegate()
            }
            .onReceive(.VeryfiLensAnalyticsEvent) { notification in
                print("[finpal - DEBUG] onReceive: \(notification)")
                logLensEvent(from: notification)
            }
        }
    }
    
    func eventListener(_ document: DocumentModel?, _ isProcessing: Bool) -> Void {
        self.isProcessing = isProcessing
        self.document = document
    }
    
    private var loadingView: some View {
        VStack(spacing: 24) {
            CircularLoaderView()
            
            Text("LOADING...")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(Color.brand60)
                .tracking(2)
        }
    }
    
    private func logLensEvent(from notification: Notification) {
        if let eventDict = notification.object as? [String: Any],
           let eventName = eventDict["event"] as? String,
           eventName == "lens_submit_document_detection_status" {
            isDocumentDetected = true
        }
        
        if let eventDict = notification.object as? [String: Any],
           let eventName = eventDict["event"] as? String,
           eventName == "lens_camera_close" {
            if !isDocumentDetected {
                tabBarState.dismissVeryfiLens()
            }
        }
    }
    
}

extension View {
    
    func onReceive(
        _ name: Notification.Name,
        center: NotificationCenter = .default,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void) -> some View {
            onReceive(
                center.publisher(for: name, object: object),
                perform: action
            )
    }
}

#Preview {
    VeryfiLensView(tabBar: TabBarState())
}
