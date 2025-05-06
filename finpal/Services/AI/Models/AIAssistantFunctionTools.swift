//
//  AIAssistantFunctionTools.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/26/25.
//

import Foundation
import OpenAI

struct AIAssistantFunctionTools {
    
    let categoryProp = (key: "category", value: [
        "type": "string",
        "description": "The category of the receipt, if it's not provided explicitly by the user, you should infer it automatically based on the title of expense."
    ])
    
    let dateProp = (key: "date", value: [
        "type": "string",
        "description": "Date of receipt. Always use this format as the response yyyy-MM-dd. If no year is provided just use current year."
    ])
    
    let totalProp = (key: "total", value: [
        "type": "string",
        "description": "Cost or total amount of the receipt."
    ])
    
    let vendorNameProp = (key: "vendor_name", value: [
        "type": "string",
        "description": "Name of the vendor associated with the receipt."
    ])
    
    func getListFunction() -> ChatQuery.ChatCompletionToolParam {
        ChatQuery.ChatCompletionToolParam(function: .init(
                name: AIAssistantFunctionType.listReceipts.rawValue,
                description: "Lists all the receipts for a given user, showing the vendor name, category, and date for each receipt.",
                parameters: .init(
                    type: .object,
                    properties: [
                        categoryProp.key: .init(type: .string, description: categoryProp.value["description"]),
                        dateProp.key: .init(type: .string, description: dateProp.value["description"]),
                        vendorNameProp.key: .init(type: .string, description: vendorNameProp.value["description"])
                    ],
                )
            )
        )
    }
}
