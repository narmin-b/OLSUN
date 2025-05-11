//
//  HomeViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation

final class HomeViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: HomeNavigation?
    weak var tabBarDelegate: HomeTabBarNavigation?
    private var accountUseCase: AccountSessionUseCase
    
    init(navigation: HomeNavigation, tabBarDelegate: HomeTabBarNavigation?, taskUseCase: AccountSessionUseCase) {
        self.navigation = navigation
        self.tabBarDelegate = tabBarDelegate
        self.accountUseCase = taskUseCase
    }
    
    // MARK: Navigations
    func userSelectedMenuItem(at index: Int) {
        tabBarDelegate?.switchToTab(index: index + 1)
    }
    
    func showLaunchScreen() {
        navigation?.showAuth()
    }
    
    func showProfileScreen() {
        navigation?.showProfile()
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
}
