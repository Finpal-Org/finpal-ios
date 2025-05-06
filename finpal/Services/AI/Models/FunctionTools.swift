//
//  FunctionTools.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 5/1/25.
//

import Foundation
import OpenAI

enum AIAssistantFunctionType: String {
    case listReceipts
    case visualizeReceipts
}

typealias PropKeyValue = (key: String, value: [String: Any])

//func createFunction() -> FunctionDeclaration {
//    FunctionDeclaration(
//        name: <#T##String#>,
//        description: <#T##String?#>,
//        parameters: JSONSchema(
//            type: <#T##JSONType#>,
//            properties: <#T##[String : Property]?#>,
//            required: <#T##[String]?#>,
//            pattern: <#T##String?#>,
//            const: <#T##String?#>,
//            enumValues: <#T##[String]?#>,
//            multipleOf: <#T##Int?#>,
//            minimum: <#T##Int?#>,
//            maximum: <#T##Int?#>
//        )
//    )
//}

let functions: [ChatQuery.ChatCompletionToolParam] = [
    
]
