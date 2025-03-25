//
//  FirebaseReceiptService.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 3/13/25.
//

import FirebaseFirestore

struct FirebaseReceiptService: ReceiptService {
    
    private var collection: CollectionReference {
        Firestore.firestore().collection("receipts")
    }
    
    func createNewReceipt(receipt: ReceiptModel) async throws {
        try collection.document("\(receipt.id)").setData(from: receipt, merge: true)
    }
}
