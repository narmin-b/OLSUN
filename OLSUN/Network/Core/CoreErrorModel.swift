//
//  CoreErrorModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 27.03.25.
//

import Foundation

struct CoreErrorModel: LocalizedError, Decodable {
    let code: Int?
    let message: String?

    var errorDescription: String? {
            return message ?? "Unknown error"
        }
    
    static func authError(code: Int) -> CoreErrorModel {
        return CoreErrorModel(code: code, message: OlsunStrings.reLoginMessage.localized)
    }

    static func generalError() -> CoreErrorModel {
        return CoreErrorModel(code: 500, message: OlsunStrings.generalError_Message.localized)
    }

    static func decodingError() -> CoreErrorModel {
        return CoreErrorModel(code: 0, message: OlsunStrings.jsonParsingError_Message.localized)
    }
}

struct ServerErrorResponse: Decodable {
    let error: String
}

struct ErrorResponse: Codable {
    let message: String
    let status: String
}

struct EmptyResponse: Decodable {}
