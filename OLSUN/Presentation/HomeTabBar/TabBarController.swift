//
//  TabBarController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import UIKit

final class TabBarController: UITabBarController {
    let customTabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    private var underlineView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupCustomTabBarView()
    }
    
    private func setupTabBar() {
        UITabBar.setTransparentTabbar()
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .black
    }
    
    private func setupCustomTabBarView() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let tabBarHeight = tabBar.frame.height + 10
        let bottomPadding = window.safeAreaInsets.bottom
        
        customTabBarView.frame = CGRect(
            x: 20,
            y: view.frame.height - tabBarHeight - bottomPadding,
            width: view.frame.width - 40,
            height: tabBarHeight
        )
//        customTabBarView.addShadow()
        customTabBarView.layer.shadowColor = UIColor.black.cgColor
        customTabBarView.layer.shadowOffset = CGSize(width: 0, height: 0)
        customTabBarView.layer.shadowOpacity = 0.1
        customTabBarView.layer.shadowRadius = 8
        customTabBarView.layer.masksToBounds = false
        
        view.addSubview(customTabBarView)
        view.bringSubviewToFront(tabBar)
    }
}

extension UITabBar {
    static func setTransparentTabbar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
