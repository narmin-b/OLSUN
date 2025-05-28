//
//  AccountSessionHelper.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 11.05.25.
//

import Foundation

enum AccountSessionHelper {
    case deleteAccount
    case userInfo
    
    var endpoint: URL? {
        switch self {
        case .deleteAccount:
            return CoreAPIHelper.instance.makeURL(path: "account/delete")
        case .userInfo:
            return CoreAPIHelper.instance.makeURL(path: "account/profile")
        }
    }
}
