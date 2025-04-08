//
//  RegisterDataModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 27.03.25.
//

import Foundation

enum Gender: String {
    case male = "MALE"
    case female = "FEMALE"
    case other = "OTHER"
}

enum Auth: String {
    case local = "LOCAL"
    case google = "GOOGLE"
    case guest = "GUEST"
}

struct RegisterDataModel {
    var username: String
    var gender: Gender
    var coupleName: String
    var coupleGender: Gender
    var email: String
    var password: String
    var confirmPassword: String
    var bday: String?
    var auth: Auth
}
