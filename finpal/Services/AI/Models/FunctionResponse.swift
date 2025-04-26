//
//  FunctionResponse.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/27/25.
//

import Foundation

struct AIAssistantResponse {
    let text: String
    let type: AIAssistantResponseFunctionType
}

enum AIAssistantResponseFunctionType {
    case listExpenses([ReceiptModel])
    case contentText
}
