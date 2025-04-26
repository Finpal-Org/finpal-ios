//
//  FinPalNetworkService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/26/25.
//

import Foundation

/**
 * FinPalNetworkService - API client to connect to our Python backend with MCP tool support
 * This service handles all communication with the AI backend server.
 */
final class FinPalNetworkService: @unchecked Sendable {
    // MARK: - Properties
    
    /// The base URL for the API
    private var apiUrl: URL
    
    /// Flag to indicate if we're connected to the server
    private var isConnected: Bool = false
    
    /// Available MCP tools from the server
    private var tools: [Any] = []
    
    // MARK: - Initialization
    
    /**
     * Initialize with a base URL (e.g., ngrok URL during development)
     */
    init(baseUrl: String = "https://finpal-2-mrufaihi.onrender.com/") {
        guard let url = URL(string: baseUrl) else {
            fatalError("Invalid base URL provided: \(baseUrl)")
        }
        self.apiUrl = url
    }
    
    // MARK: - Public Methods
    
    /**
     * Connect to the AI backend server
     * Returns a boolean indicating if the connection was successful
     */
    func connectToServer() async throws -> Bool {
        // Check if the backend is running via health endpoint
        let healthEndpoint = apiUrl.appendingPathComponent("api/health")
        
        let (healthData, _) = try await URLSession.shared.data(from: healthEndpoint)
        
        if let healthJson = try? JSONSerialization.jsonObject(with: healthData) as? [String: Any],
           let connected = healthJson["connected"] as? Bool, connected {
            self.isConnected = true
            
            // Always get a fresh list of tools
            let connectEndpoint = apiUrl.appendingPathComponent("api/connect")
            
            var request = URLRequest(url: connectEndpoint)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: [:])
            
            let (connectData, _) = try await URLSession.shared.data(for: request)
            
            if let connectJson = try? JSONSerialization.jsonObject(with: connectData) as? [String: Any],
               let toolsArray = connectJson["tools"] as? [Any] {
                self.tools = toolsArray
                print("Connected with \(tools.count) tools available")
            }
            
            return true
        } else {
            // Try to initialize connection
            let connectEndpoint = apiUrl.appendingPathComponent("api/connect")
            
            var request = URLRequest(url: connectEndpoint)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: [:])
            
            let (connectData, _) = try await URLSession.shared.data(for: request)
            
            if let connectJson = try? JSONSerialization.jsonObject(with: connectData) as? [String: Any],
               let status = connectJson["status"] as? String, status == "connected" {
                self.isConnected = true
                
                if let toolsArray = connectJson["tools"] as? [Any] {
                    self.tools = toolsArray
                    print("Connected with \(tools.count) tools available")
                }
                
                return true
            }
        }
        
        return false
    }
    
    /**
     * Process a user message through the AI
     * Returns the response from the server
     */
    func processQuery(_ query: String) async throws -> String {
        guard isConnected else {
            return "Error: Not connected to the AI service. Please try again later."
        }
        
        let chatEndpoint = apiUrl.appendingPathComponent("api/chat")
        
        var request = URLRequest(url: chatEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["message": query]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let responseJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let response = responseJson["response"] as? String {
            return response
        } else {
            throw NSError(domain: "FinPalNetworkService", code: 1002,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
        }
    }
    
    /**
     * Check if connected to the AI service
     */
    func isServerConnected() -> Bool {
        return isConnected
    }
    
    /**
     * Get list of available tools
     */
    func getTools() -> [Any] {
        return tools
    }
}
