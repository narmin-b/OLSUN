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
    
    var endpoint: URL? {
        switch self {
        case .register:
            return CoreAPIHelper.instance.makeURL(path: "test/auth/register")
        case .login:
            return CoreAPIHelper.instance.makeURL(path: "test/auth/login")
        }
    }
}
