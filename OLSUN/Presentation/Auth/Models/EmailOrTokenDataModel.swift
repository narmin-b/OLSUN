//
//  EmailOrTokenDataModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 29.04.25.
//

import Foundation

enum GoogleCheckStatus: String, Codable {
    case email = "EMAIL"
    case token = "TOKEN"
}

struct EmailOrTokenDataModel: Codable {
    var status: GoogleCheckStatus
    var message: String
}

