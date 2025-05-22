//
//  GuestLoginDataModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 15.05.25.
//

enum GuestStatus: String, Codable {
    case error = "ERROR"
    case success = "SUCCESS"
}

struct GuestLoginDataModel: Codable {
    var message: String?
    var token: String?
    var status: GuestStatus?
}
