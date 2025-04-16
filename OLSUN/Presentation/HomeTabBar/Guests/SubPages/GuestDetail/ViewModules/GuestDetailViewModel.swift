//
//  TaskViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import Foundation

final class GuestDetailViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case editSuccess
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: GuestsNavigation?
    var taskItem: ListCellProtocol
    private var guestUseCase: GuestUseCase
    
    init(navigation: GuestsNavigation, guestUseCase: GuestUseCase, taskItem: ListCellProtocol) {
        self.navigation = navigation
        self.guestUseCase = guestUseCase
        self.taskItem = taskItem
        print(taskItem)
    }
    
    // MARK: Navigations
    func popControllerBack() {
        navigation?.popController()
    }
    
    func showEditGuest() {
        let guest = ListCellProtocol(
            titleString: taskItem.titleString,
            dateString: taskItem.dateString,
            statusString: taskItem.statusString,
            idInt: taskItem.idInt
        )
        
        navigation?.showEditGuest(guestItem: guest) { [weak self] updatedGuest in
            guard let self = self else { return }
            self.taskItem = updatedGuest
            self.requestCallback?(.success)
        }
    }
    
    // MARK: Requests
    func editGuest(guest: GuestDataModel) {
        requestCallback?(.loading)
        guestUseCase.editGuest(guest: guest) { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if result != nil {
                    self.requestCallback?(.editSuccess)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
}
