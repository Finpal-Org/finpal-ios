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
    
    func createNewReceipt(receipt: ReceiptModel, receiptImage: UIImage?, vendorName: String, vendorLogo: UIImage) async throws {
        let vendorImageName = UUID().uuidString
        let vendorImagePath = "receipts/\(receipt.id)/\(vendorImageName)"
        let vendorImageURL = try await FirebaseImageUploadService().uploadImage(image: vendorLogo, path: vendorImagePath)
        
        let vendor = VendorModel(name: vendorName, logoURL: vendorImageURL.absoluteString)
        
        var saveReceipt = ReceiptModel(
            id: receipt.id,
            userId: receipt.userId,
            category: receipt.category,
            date: receipt.date,
            invoiceNumber: receipt.invoiceNumber,
            isDuplicate: receipt.isDuplicate,
            lineItems: receipt.lineItems,
            payment: receipt.payment,
            subtotal: receipt.subtotal,
            tax: receipt.tax,
            total: receipt.total,
            note: receipt.note,
            vendor: vendor
        )
        
        if let receiptImage {
            let receiptImageName = UUID().uuidString
            let receiptImagePath = "receipts/\(receipt.id)/\(receiptImageName)"
            let receiptImageURL = try await FirebaseImageUploadService().uploadImage(image: receiptImage, path: receiptImagePath)
            
            saveReceipt.updateReceiptImage(imageName: receiptImageURL.absoluteString)
        }
        
        try collection.document(saveReceipt.id).setData(from: saveReceipt, merge: true)
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
            .whereField(ReceiptModel.CodingKeys.userId.rawValue, isEqualTo: userId)
            .order(by: ReceiptModel.CodingKeys.date.rawValue, descending: true)
            .getAllDocuments()
    }
    
    func removeAuthorIdFromReceipt(receiptId: String) async throws {
        
    }
    
    func removeAuthorIdFromAllUserReceipts(userId: String) async throws {
        
    }
}
