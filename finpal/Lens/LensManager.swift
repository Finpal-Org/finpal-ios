//
//  LensManager.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/21/25.
//

import UIKit
import VeryfiLens

class LensManager {
    typealias EventListener = ((_ json: [String: Any], _ document: DocumentModel?) -> Void)
    var eventListener: EventListener?
    
    func configure() {
        let CLIENT_ID = KeysConfiguration.clientId
        let AUTH_USERNAME = KeysConfiguration.authUsername
        let AUTH_APIKEY = KeysConfiguration.authApiKey
        let URL = "https://api.veryfi.com/"
        
        let credentials: VeryfiLensCredentials = VeryfiLensCredentials(
            clientId: CLIENT_ID,
            username: AUTH_USERNAME,
            apiKey: AUTH_APIKEY,
            url: URL
        )
        
        let settings = VeryfiLensSettings()
        settings.autoCaptureIsOn = true
        settings.documentTypes = ["receipt"]
        settings.dataExtractionEngine = .cloudAPI
        settings.parseAddressIsOn = true
        
        VeryfiLens.shared().configure(with: credentials, settings: settings)
    }
    
    @MainActor
    func showCamera() {
        if let rootViewController = UIApplication.shared.currentUIWindow()?.rootViewController {
            VeryfiLens.shared().showCamera(in: rootViewController)
        }
    }
    
    func setDelegate(eventListener: @escaping EventListener) {
        self.eventListener = eventListener
        VeryfiLens.shared().delegate = self
    }
    
    func removeDelegate() {
        self.eventListener = nil
        VeryfiLens.shared().delegate = nil
    }
    
    private func decodeReceipt(from json: [String: Any]) -> Receipt? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            let decoder = JSONDecoder()
            let receipt = try decoder.decode(Receipt.self, from: jsonData)
            return receipt
        } catch {
            print("[DEBUG] Cannot decode JSON.")
            print(error)
            return nil
        }
    }
    
    func getData(from json: [String : Any]) -> DocumentModel? {
        guard let data = getJsonData(from: json) else { return nil }
        
        do {
            let decodedDocument = try JSONDecoder().decode(DocumentModel.self, from: data)
            print("[DEBUG] Successfully decoded DocumentModel.")
            return decodedDocument
        } catch {
            print("[DEBUG] Failed to decode DocumentModel.")
            return nil
        }
    }
    
    func getJsonData(from json: [String: Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return jsonData
    }
}

extension LensManager: VeryfiLensDelegate {
    
    func veryfiLensClose(_ json: [String: Any]) {
        eventListener?(json, nil)
    }
    
    func veryfiLensError(_ json: [String: Any]) {
        eventListener?(json, nil)
    }
    
    func veryfiLensSuccess(_ json: [String: Any]) {
        if let document = getData(from: json) {
            eventListener?(json, document)
        } else {
            print("[ERROR] Failed to decode receipt")
        }
//        if let document = decodeReceipt(from: json) {
//            eventListener?(json, document)
//        } else {
//            print("[ERROR] Failed to decode receipt")
//        }
    }
    
    func veryfiLensUpdate(_ json: [String: Any]) {
        eventListener?(json, nil)
    }
}
