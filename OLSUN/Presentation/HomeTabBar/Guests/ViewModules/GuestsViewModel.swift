//
//  GuestsViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation

final class GuestsViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: GuestsNavigation?
    private var guestUseCase: GuestUseCase
    var guestList: [ListCellProtocol] = []
    
    init(navigation: GuestsNavigation, guestUseCase: GuestUseCase) {
        self.navigation = navigation
        self.guestUseCase = guestUseCase
    }
    
    func taskSelected(taskItem: ListCellProtocol) {
        navigation?.showTask(taskItem: taskItem)
    }
    
    func showAddGuestVC() {
        navigation?.showAddGuest()
    }
    
    func getAllGuests() {
        requestCallback?(.loading)
        guestUseCase.getGuestList { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let result = result {
                    self.guestList = (result.map({$0.mapToDomain()}))/*.reversed()*/
                    print(self.guestList)
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
}
