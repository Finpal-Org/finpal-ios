//
//  CSVFile.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/24/25.
//

import CoreTransferable

struct CSVFile {
    var receipts: [ReceiptModel]
    
    init(receipts: [ReceiptModel]) {
        self.receipts = receipts
    }
}

extension CSVFile {
    
    func csvData() -> String {
        let table = CSVTable<ReceiptModel>(
            columns: [
                CSVColumn("ID", \.id),
                CSVColumn("Vendor", \.vendor?.name),
                CSVColumn("Date", \.date),
                CSVColumn("Category", \.category.rawValue),
                CSVColumn("Invoice No.", \.invoiceNumber),
                CSVColumn("Subtotal", \.subtotal),
                CSVColumn("Tax (15%)", \.tax),
                CSVColumn("Total", \.total),
                CSVColumn("Items", attribute: { receipt in
                    receipt.lineItems.map { item in
                        "[\(item.id):\(item.quantity)x\(item.description.replacingOccurrences(of: ",", with: " "))=SAR\(String(format: "%.2f", item.total))]"
                    }
                    .joined(separator: "|")
                })
            ],
            configuration: CSVEncoderConfiguration(dateEncodingStrategy: .iso8601)
        )
        
        return table.export(rows: receipts)
    }
}

extension CSVFile: Transferable {
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .commaSeparatedText) { file in
            Data(file.csvData().utf8)
        }
    }
}
