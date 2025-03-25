//
//  PhotoViewModel.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/23/25.
//

import SwiftUI
import Firebase
import FirebaseStorage

class PhotoViewModel {
    
    static func saveImage(receiptId: String, vendorName: String, data: Data) async -> VendorModel? {
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        let photoName = UUID().uuidString // Unique filename for the vendor logo photo
        
        metadata.contentType = "image/jpeg"
        
        let path = "receipts/\(receiptId)/\(photoName)"
        
        do {
            let storageRef = storage.child(path)
            let _ = try await storageRef.putDataAsync(data, metadata: metadata)
            
            guard let url = try? await storageRef.downloadURL() else {
                print("[finpal - ERROR] Could not download URL from Firebase Storage.")
                return nil
            }
            
            let newVendor = VendorModel(
                name: vendorName,
                logoURL: url.absoluteString
            )
            
            return newVendor
        } catch {
            print("[finpal - ERROR] Failed to save image to Firebase Storage: \(error.localizedDescription)")
            return nil
        }
    }
    
}
