//
//  GuestsNavigation.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//


import Foundation

protocol GuestsNavigation: AnyObject {
    func showGuest(guestItem: ListCellProtocol)
    func showEditGuest(guestItem: ListCellProtocol, onUpdate: @escaping (ListCellProtocol) -> Void)
    func showAddGuest()
    func popController()
    func popTwoControllersBack()
    func showProfile()
}
