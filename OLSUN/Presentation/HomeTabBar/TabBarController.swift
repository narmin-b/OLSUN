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
        view.backgroundColor = .accentMain
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    private var underlineView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setupTabBar()
        setupCustomTabBarView()
        setupUnderlineIndicator()
    }
    
    private func setupTabBar() {
        UITabBar.setTransparentTabbar()
        tabBar.barTintColor = .accentMain
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
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
        
        view.addSubview(customTabBarView)
        view.bringSubviewToFront(tabBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUnderlinePosition(animated: false)
    }

    private func setupUnderlineIndicator() {
        let itemCount = CGFloat(tabBar.items?.count ?? 1)
        
        let tabWidth = tabBar.frame.width / itemCount
        let underlineWidth: CGFloat = 28
        let underlineHeight: CGFloat = 4
        let underlineYPosition: CGFloat = tabBar.frame.height - 10
        
        let underline = UIView(frame: CGRect(
            x: (tabWidth - underlineWidth) / 2,
            y: underlineYPosition,
            width: underlineWidth,
            height: underlineHeight
        ))
        
        underline.backgroundColor = .white
        underline.layer.cornerRadius = underlineHeight / 2
        tabBar.addSubview(underline)
        
        underlineView = underline
        updateUnderlinePosition(animated: false)
    }
    
    private func updateUnderlinePosition(animated: Bool) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: tabBar.selectedItem ?? UITabBarItem()) else { return }
        
        let itemCount = CGFloat(tabBar.items?.count ?? 1)
        let tabWidth = tabBar.frame.width / itemCount
        let underlineWidth: CGFloat = 28
        let firstTabCenterX = tabWidth / 2 - underlineWidth / 2
        let targetX = firstTabCenterX + CGFloat(selectedIndex) * tabWidth
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                if selectedIndex == 0 {
                    self.underlineView?.frame.origin.x = firstTabCenterX
                    return
                }
                self.underlineView?.frame.origin.x = targetX
            }
        } else {
            if selectedIndex == 0 {
                self.underlineView?.frame.origin.x = firstTabCenterX
                return
            }
            underlineView?.frame.origin.x = targetX
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateUnderlinePosition(animated: true)
    }
}

extension UITabBar {
    static func setTransparentTabbar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
