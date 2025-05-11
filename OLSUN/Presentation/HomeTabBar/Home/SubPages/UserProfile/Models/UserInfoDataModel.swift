//
//  UserInfoDataModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.05.25.
//

import Foundation

struct UserInfoDataModel: Codable {
    var username: String
    var coupleName: String?
    var gender: Gender?
    var email: String?
    var age: String?
}
