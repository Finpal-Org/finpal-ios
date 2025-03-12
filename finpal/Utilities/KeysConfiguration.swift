//
//  KeysConfiguration.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/12/25.
//

import Foundation

public enum KeysConfiguration {
    enum Keys {
        static let clientId = "CLIENT_ID"
        static let authUsername = "AUTH_USERNAME"
        static let authApiKey = "AUTH_APIKEY"
    }
    
    nonisolated(unsafe) private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let clientId: String = {
        guard let clientIdString = KeysConfiguration.infoDictionary[Keys.clientId] as? String else {
            fatalError("Client ID not set in plist")
        }
        return clientIdString
    }()
    
    static let authUsername: String = {
        guard let authUsernameString = KeysConfiguration.infoDictionary[Keys.authUsername] as? String else {
            fatalError("Veryfi Auth Username not set in plist")
        }
        return authUsernameString
    }()
    
    static let authApiKey: String = {
        guard let authApiKeyString = KeysConfiguration.infoDictionary[Keys.authApiKey] as? String else {
            fatalError("Veryfi Auth API Key not set in plist")
        }
        return authApiKeyString
    }()
    
}
