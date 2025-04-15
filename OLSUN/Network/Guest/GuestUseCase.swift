//
//  GuestUseCase.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 15.04.25.
//

import Foundation

protocol GuestUseCase {
    func addGuest(guest: GuestDataModel, completion: @escaping(String?, String?) -> Void)
    func getGuestList(completion: @escaping([GuestDataModel]?, String?) -> Void)
    func editGuest(guest: GuestDataModel, completion: @escaping(String?, String?) -> Void)
    func deleteGuest(id: Int, completion: @escaping(String?, String?) -> Void)
}
