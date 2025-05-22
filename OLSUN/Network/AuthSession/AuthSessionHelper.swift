//
//  AuthSessionHelper.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 27.03.25.
//

import Foundation

enum AuthSessionHelper {
    case register
    case login
    case guestLogin
    case googleLogin
    case googleCheck
    case appleCheck
    
    var endpoint: URL? {
        switch self {
        case .register:
            return CoreAPIHelper.instance.makeURL(path: "test/auth/register")
        case .login:
            return CoreAPIHelper.instance.makeURL(path: "test/auth/login")
        case .guestLogin:
            return CoreAPIHelper.instance.makeURL(path: "test/auth/guest-register")
        case .googleLogin:
            return CoreAPIHelper.instance.makeURL(path: "auth/google/register")
        case .googleCheck:
            return CoreAPIHelper.instance.makeURL(path: "auth/google/email")
        case .appleCheck:
            return CoreAPIHelper.instance.makeURL(path: "apple/auth/apple")
        }
    }
}
