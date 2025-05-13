//
//  UserDefaultsKey.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import Foundation

enum LoginType: String {
    case user
    case guest
}

enum UserDefaultsKey: String {
    case isLoggedIn
    case appLanguage
    case loginType
}

