//
//  TabBarController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import UIKit

final class TabBarController: UITabBarController {

    private var topBorder: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTopBorderToTabBar()
    }

    private func setupTabBar() {
        tabBar.barTintColor = .white
        tabBar.tintColor = .tabbarHighlight
        tabBar.unselectedItemTintColor = .tabbar
    }

    private func addTopBorderToTabBar() {
        topBorder?.removeFromSuperview()

        let lineHeight: CGFloat = 0.5
        let lineView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: tabBar.bounds.width,
            height: lineHeight
        ))
        lineView.backgroundColor = .lightGray
        lineView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]

        tabBar.addSubview(lineView)
        topBorder = lineView
    }
}

//final class TabBarController: UITabBarController {
//    let customTabBarView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 30
//        view.layer.masksToBounds = true
//        return view
//    }()
//    
//    private var underlineView: UIView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupTabBar()
//        setupCustomTabBarView()
//        
//        // Listen for app foreground events
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(appWillEnterForeground),
//            name: UIApplication.willEnterForegroundNotification,
//            object: nil
//        )
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
////        showFeedbackPopupIfNeeded()
//    }
//
//    @objc private func appWillEnterForeground() {
////
//    }
//    
//    private func showFeedbackPopupIfNeeded() {
//        // Prevent multiple popups if already shown
////        if view.subviews.contains(where: { $0 is FeedbackPopupView }) { return }
//        
//        let feedbackPopup = FeedbackPopupView(frame: UIScreen.main.bounds)
//        feedbackPopup.configure(
//            title: OlsunStrings.feedbackPopupTitle.localized,
//            message: OlsunStrings.feedbackPopupSubtitle.localized
//        )
//        feedbackPopup.onSubmit = { [weak self, weak feedbackPopup] in
//            feedbackPopup?.removeFromSuperview()
//            self?.showFeedbackController()
//        }
//        feedbackPopup.onCancel = { [weak feedbackPopup] in
//            feedbackPopup?.removeFromSuperview()
//        }
//        view.addSubview(feedbackPopup)
//    }
//    
//    private func showFeedbackController() {
//        let feedbackVC = FeedbackViewController()
//        feedbackVC.modalPresentationStyle = .formSheet
//        self.present(feedbackVC, animated: true, completion: nil)
//    }
//    
//    private func setupTabBar() {
//        UITabBar.setTransparentTabbar()
//        tabBar.barTintColor = .white
//        tabBar.tintColor = .black
//        tabBar.unselectedItemTintColor = .black
//    }
//    
//    private func setupCustomTabBarView() {
//        guard DeviceSizeClass.current != .iPad else { return }
//
//        guard let window = UIApplication.shared.windows.first else { return }
//
//        let tabBarHeight = tabBar.frame.height + 15
//        let bottomPadding = window.safeAreaInsets.bottom
//
//        customTabBarView.frame = CGRect(
//            x: 10,
//            y: view.frame.height - tabBarHeight - bottomPadding + 10,
//            width: view.frame.width - 20,
//            height: tabBarHeight
//        )
//        customTabBarView.layer.shadowColor = UIColor.black.cgColor
//        customTabBarView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        customTabBarView.layer.shadowOpacity = 0.1
//        customTabBarView.layer.shadowRadius = 8
//        customTabBarView.layer.masksToBounds = false
//
//        view.addSubview(customTabBarView)
//        view.bringSubviewToFront(tabBar)
//    }
//}
//
//extension UITabBar {
//    static func setTransparentTabbar() {
//        UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().clipsToBounds = true
//    }
//}
