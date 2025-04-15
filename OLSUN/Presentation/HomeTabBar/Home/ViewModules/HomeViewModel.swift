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
    
    init(navigation: HomeNavigation, tabBarDelegate: HomeTabBarNavigation?) {
        self.navigation = navigation
        self.tabBarDelegate = tabBarDelegate
    }
    
    func userSelectedMenuItem(at index: Int) {
        tabBarDelegate?.switchToTab(index: index + 1)
    }
    
    func showLaunchScreen() {
        navigation?.showAuth()
    }
}
