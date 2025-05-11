//
//  UserProfileViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 11.05.25.
//

import Foundation

final class UserProfileViewModel {
    enum ViewState {
        case refreshError(message: String)
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: UserProfileNavigation?
    private var accountUseCase: AccountSessionUseCase
    private var user: UserInfoDataModel = UserInfoDataModel(username: "")
    
    init(navigation: UserProfileNavigation, accountUseCase: AccountSessionUseCase) {
        self.navigation = navigation
        self.accountUseCase = accountUseCase
    }
    
    func deleteAccount() {
        requestCallback?(.loading)
        accountUseCase.deleteAccount { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                Logger.debug("dto: \(dto ?? "No resp")")
                
                if dto != nil {
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func getUserInfo() {
        requestCallback?(.loading)
        accountUseCase.getUserInfo { [weak self] dto, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.requestCallback?(.loaded)
                Logger.debug("dto: \(dto!)")
                if let dto = dto {
                    self.user = dto
                    print(self.user)

                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
}
