//
//  VeryfiLensManager.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/15/25.
//

import UIKit
import VeryfiLens

class VeryfiLensManager {
    
    private var tabBarState: TabBarState
    private var eventListener: ((_ document: DocumentModel?, _ isProcessing: Bool) -> Void)?
    
    init(tabBarState: TabBarState) {
        self.tabBarState = tabBarState
    }
    
    func configure() {
        let CLIENT_ID = Keys.veryfiClientID
        let AUTH_USERNAME = Keys.veryfiAuthUsername
        let AUTH_APIKEY = Keys.veryfiAuthAPIKey
        let URL = "https://api.veryfi.com/"
        
        let credentials = VeryfiLensCredentials(
            clientId: CLIENT_ID,
            username: AUTH_USERNAME,
            apiKey: AUTH_APIKEY,
            url: URL
        )
        
        let settings = VeryfiLensSettings()
        
        settings.customLensStrings = [
            "en": [
                "Whoops, it looks like there are no documents in this image.": "No document detected in this image. Please ensure the receipt is clearly visible.",
                "Try again": "Retake Photo",
                "I'm happy with it": "Use This Image",
                
                "Cancel capturing?": "Cancel Capture?",
                "All images captured in this session will be discarded": "If you proceed, all captured images in this session will be lost. Are you sure you want to continue?",
                "Ok": "Discard Images",
                "No Thanks": "Keep Capturing",
                
                "Remove this Document?": "Delete This Receipt?"
            ]
        ]
        
        settings.autoCaptureIsOn = true
        settings.documentTypes = ["receipt"]
        settings.dataExtractionEngine = .cloudAPI
        settings.parseAddressIsOn = true
        
        settings.submitButtonBackgroundColor = "65A30D"
        settings.submitButtonCornerRadius = 26
        
        VeryfiLens.shared().configure(with: credentials, settings: settings)
    }
    
    @MainActor func showCamera() {
        if let rootViewController = UIApplication.shared.currentUIWindow()?.rootViewController {
            VeryfiLens.shared().showCamera(in: rootViewController)
        }
    }
    
    func setDelegate(eventListener: @escaping ((_ document: DocumentModel?, _ isProcessing: Bool) -> Void)) {
        self.eventListener = eventListener
        VeryfiLens.shared().delegate = self
    }
    
    func removeDelegate() {
        self.eventListener = nil
        VeryfiLens.shared().delegate = nil
    }
    
    private func getData(from json: [String: Any]) -> DocumentModel? {
        guard let data = getJsonData(from: json) else { return nil }
        
        do {
            let decodedDocument = try JSONDecoder().decode(DocumentModel.self, from: data)
            return decodedDocument
        } catch {
            return nil
        }
    }
    
    private func getJsonData(from json: [String: Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return jsonData
    }
}

extension VeryfiLensManager: VeryfiLensDelegate {
    
    func veryfiLensClose(_ json: [String: Any]) {
        
    }
    
    func veryfiLensError(_ json: [String: Any]) {
        eventListener?(nil, false)
    }
    
    func veryfiLensSuccess(_ json: [String: Any]) {
        if let document = getData(from: json) {
            
            if document.data.total == nil {
                eventListener?(nil, false)
            } else {
                eventListener?(document, false)
            }
            
        } else {
            eventListener?(nil, false)
        }
    }
    
    func veryfiLensUpdate(_ json: [String: Any]) {
        
    }
}
