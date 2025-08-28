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
    private var vendorUseCase: VendorUseCase
    weak var tabBarDelegate: HomeTabBarNavigation?
    
    init(navigation: HomeNavigation, tabBarDelegate: HomeTabBarNavigation?, vendorUseCase: VendorUseCase) {
        self.navigation = navigation
        self.tabBarDelegate = tabBarDelegate
        self.vendorUseCase = vendorUseCase
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
    
    func setHomeClick() {
        vendorUseCase.setHomeScreenClick { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let result = result {
                   print("count success")
                } else if let error = error {
                    print("count error")
                }
            }
        }
    }
}
