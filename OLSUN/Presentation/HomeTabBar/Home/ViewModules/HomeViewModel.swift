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
        switch index {
        case 0:
            tabBarDelegate?.switchToTab(index: 1)
        case 1:
            showPlanningScreen()
        case 2:
            showGuestsScreen()
        default:
            return
        }
    }
    
    func showLaunchScreen() {
        navigation?.showAuth()
    }
    
    func showPlanningScreen() {
        navigation?.showPlanning()
    }
    
    func showGuestsScreen() {
        navigation?.showGuests()
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
