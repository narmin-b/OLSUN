//
//  AddGuestViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import Foundation

enum GuestMode {
    case edit
    case add
}

final class AddGuestViewModel {
    enum ViewState {
        case loading
        case loaded
        case editSuccess(guest: ListCellProtocol)
        case deleteSuccess
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: GuestsNavigation?
    private var guestUseCase: GuestUseCase
    var guestMode: GuestMode
    var guestItem: ListCellProtocol
    
    init(navigation: GuestsNavigation, guestUseCase: GuestUseCase, guestMode: GuestMode, guestItem: ListCellProtocol) {
        self.navigation = navigation
        self.guestUseCase = guestUseCase
        self.guestMode = guestMode
        self.guestItem = guestItem
        print(guestItem)
        print(guestMode)
    }
    
    // MARK: Navigations
    func popControllerBack() {
        navigation?.popController()
    }
    
    // MARK: Requests
    func performEdit(guest: GuestDataModel) {
        switch guestMode {
        case .edit:
            editGuest(guest: guest)
        case .add:
            addGuest(guest: guest)
        }
    }
    
    func addGuest(guest: GuestDataModel) {
        requestCallback?(.loading)
        guestUseCase.addGuest(guest: guest) { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if result != nil {
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func editGuest(guest: GuestDataModel) {
        requestCallback?(.loading)
        guestUseCase.editGuest(guest: guest) { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if result != nil {
                    let newGuest = guest.mapToDomain()
                    self.requestCallback?(.editSuccess(guest: newGuest))
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func deleteGuest(id: Int) {
        requestCallback?(.loading)
        guestUseCase.deleteGuest(id: id) { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if result != nil {
                    self.navigation?.popTwoControllersBack()
                    self.requestCallback?(.deleteSuccess)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
}
