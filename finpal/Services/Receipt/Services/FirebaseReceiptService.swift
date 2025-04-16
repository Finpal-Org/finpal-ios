//
//  FirebaseReceiptService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import FirebaseFirestore
import SwiftfulFirestore

struct FirebaseReceiptService: ReceiptService {
    
    private var collection: CollectionReference {
        Firestore.firestore().collection("receipts")
    }
    
    func createNewReceipt(receipt: ReceiptModel, vendorName: String, vendorLogo: UIImage) async throws {
        let photoName = UUID().uuidString
        let path = "receipts/\(receipt.receiptId)/\(photoName)"
        let url = try await FirebaseImageUploadService().uploadImage(image: vendorLogo, path: path)
        
        let vendor = VendorModel(name: vendorName, logoURL: url.absoluteString)
        
        var receipt = receipt
        receipt.updateVendor(vendor)
        
        try collection.document(receipt.receiptId).setData(from: receipt, merge: true)
    }
    
    func getReceipt(id: String) async throws -> ReceiptModel {
        try await collection.getDocument(id: id)
    }
    
    func getReceiptsForCategory(category: CategoryModel) async throws -> [ReceiptModel] {
        try await collection
            .whereField(ReceiptModel.CodingKeys.category.rawValue, isEqualTo: category.rawValue)
            .limit(to: 200)
            .getAllDocuments()
    }
    
    func getReceiptsForAuthor(userId: String) async throws -> [ReceiptModel] {
        try await collection
            .whereField(ReceiptModel.CodingKeys.authorId.rawValue, isEqualTo: userId)
            .limit(to: 200)
            .getAllDocuments()
    }
    
    func removeAuthorIdFromReceipt(receiptId: String) async throws {
        
    }
    
    func removeAuthorIdFromAllUserReceipts(userId: String) async throws {
        
    }
}
