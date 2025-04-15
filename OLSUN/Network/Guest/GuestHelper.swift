//
//  GuestHelper.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 15.04.25.
//

import Foundation

enum GuestHelper {
    case addGuest
    case editGuest(id: Int)
    case allGuestList
    case deleteGuest(id: Int)
    
    var endpoint: URL? {
        switch self {
        case .addGuest:
            return CoreAPIHelper.instance.makeURL(path: "guest/guestAdd")
        case .editGuest(let id):
            return CoreAPIHelper.instance.makeURL(path: "guest/update-guest/\(id)")
        case .allGuestList:
            return CoreAPIHelper.instance.makeURL(path: "guest/by-user")
        case .deleteGuest(let id):
            return CoreAPIHelper.instance.makeURL(path: "guest/delete/\(id)")
        }
    }
}
