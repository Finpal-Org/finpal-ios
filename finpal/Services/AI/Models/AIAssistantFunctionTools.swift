//
//  AIAssistantFunctionTools.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/26/25.
//

import Foundation
import OpenAI

enum AIAssistantFunctionType: String {
    case listReceipts
    case visualizeReceipts
}

struct AIAssistantFunctionTools {
    
    let vendorNameProp = (key: "vendor_name", value: [
        "type": "string",
        "description": "Name of the vendor associated with the receipt."
    ])
    
    let dateProp = (key: "date", value: [
        "type": "string",
        "description": "Date of receipt. Always use this format as the response yyyy-MM-dd. If no year is provided just use current year."
    ])
    
    let categoryProp = (key: "category", value: [
        "type": "string",
        "description": "The category of the receipt, if it's not provided explicitly by the user, you should infer it automatically based on the title of expense."
    ])
    
    func getFunctions() -> [FunctionDeclaration] {
        [
            FunctionDeclaration(
                name: AIAssistantFunctionType.listReceipts.rawValue,
                description: "Lists all the receipts for a given user, showing the vendor name, category, and date for each receipt.",
                parameters: JSONSchema(
                    type: .object,
                    properties: [
                        vendorNameProp.key: .init(type: .string, description: vendorNameProp.value["description"]),
                        dateProp.key: .init(type: .string, description: dateProp.value["description"]),
                        categoryProp.key: .init(type: .string, description: categoryProp.value["description"], enumValues: CategoryModel.allCases.map { $0.rawValue })
                    ],
                )
            ),
            
//            FunctionDeclaration(
//                name: <#T##String#>,
//                description: <#T##String?#>,
//                parameters: <#T##JSONSchema?#>
//            )
        ]
    }
}
