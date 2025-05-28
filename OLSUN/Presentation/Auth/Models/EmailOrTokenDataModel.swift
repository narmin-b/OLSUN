//
//  EmailOrTokenDataModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 29.04.25.
//

import Foundation

enum SignInCheckStatus: String, Codable {
    case email = "EMAIL"
    case token = "TOKEN"
    case appleId = "APPLE_ID"
}

struct EmailOrTokenDataModel: Codable {
    var status: SignInCheckStatus
    var message: String
}
