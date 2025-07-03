//
//  HomeViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import UIKit
import SkeletonView

final class HomeViewController: BaseViewController {
    // MARK: UI Elements
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var homeImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.isSkeletonable = true
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.homeListText.localized,
            labelColor: .primaryHighlight,
            labelFont: .workSansBold,
            labelSize: 28,
            numOfLines: 1
        )
        label.accessibilityIdentifier = "homeTitleLabel"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var menuTableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(MenuTableCell.self, forCellReuseIdentifier: "MenuTableCell")
        tableview.separatorStyle = .none
        tableview.backgroundColor = .clear
        tableview.isScrollEnabled = false
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    // MARK: Configurations
    private let viewModel: HomeViewModel?
    
    var menuItems: [MenuItem] = [
        MenuItem(
            iconName: "partnersIcon",
            title: OlsunStrings.partnersText.localized,
            description: OlsunStrings.partnersDesc.localized
        ),
        MenuItem(
            iconName: "planningIcon",
            title: OlsunStrings.planningText.localized,
            description: OlsunStrings.planningDesc.localized
        ),
        MenuItem(
            iconName: "guestsIcon",
            title: OlsunStrings.guestText.localized,
            description: OlsunStrings.guestDesc.localized
        )
    ]
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        viewModel?.requestCallback = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        print("key: \(KeychainHelper.getString(key: .userID) ?? "")")


        print("Language code: \(LocalizationManager.shared.currentLanguage)")
        print("Language code in UD: \(UserDefaultsHelper.getString(key: .appLanguage))")

        
        homeImageView.loadImage(named: "/img/app/homeImage.png")
        Logger.debug("\(KeychainHelper.getString(key: .userID) ?? "")")
    }
    
    override func configureView() {
        configureNavigationBar()
        print(KeychainHelper.getString(key: .userID) ?? "")
        view.backgroundColor = .white
        view.addSubViews(loadingView, homeImageView, titleLabel, menuTableView)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        homeImageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            padding: .init(all: 0)
        )
        homeImageView.anchorSize(.init(width: view.frame.width, height: view.frame.width*0.506))
        
        titleLabel.anchor(
            top: homeImageView.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 12, left: 16, bottom: 0, right: 0)
        )
        
        menuTableView.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 16, left: 16, bottom: -12, right: -16)
        )
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
        navigationController?.navigationBar.backgroundColor = .white
        
        let logo = UIImage(named: "olsunHomeLogo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 76, height: 76)
        
        let logoItem = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = logoItem
        
        let profileButton = UIBarButtonItem(
            image: UIImage(named: "profile"),
            style: .plain,
            target: self,
            action: #selector(profileTabClicked)
        )
        
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logOutClicked)
        )
        
        let toggleLangButton = UIBarButtonItem(
            title: LocalizationManager.shared.currentLanguage == "en" ? "EN" : "AZ",
            style: .plain,
            target: self,
            action: #selector(toggleLanguage)
        )
        toggleLangButton.tintColor = .primaryHighlight
        profileButton.tintColor = .primaryHighlight
        
        if UserDefaultsHelper.getString(key: .loginType) == "guest" {
            navigationItem.rightBarButtonItems = [logoutButton, toggleLangButton]
        } else {
            navigationItem.rightBarButtonItems = [profileButton, toggleLangButton]
        }
    }
    
    private func configureViewModel() {
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.loadingView.startAnimating()
                case .loaded:
                    self.loadingView.stopAnimating()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                case .success:
                    UserDefaultsHelper.setBool(key: .isLoggedIn, value: false)
                    self.showMessage(
                        title: OlsunStrings.updateSuccessText.localized,
                        message: OlsunStrings.accDelete_Success.localized
                    ) {
                        self.viewModel?.showLaunchScreen()
                    }
                }
            }
        }
    }
    
    // MARK: Functions
    @objc private func profileTabClicked() {
        viewModel?.showProfileScreen()
    }
    
    @objc fileprivate func logOutClicked() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let confirmation = ConfirmationView(frame: UIScreen.main.bounds)
        confirmation.configure(
            title: OlsunStrings.confirmationTitle.localized,
            message: OlsunStrings.guestLogoutMessage.localized,
            confirmButtonTitle: OlsunStrings.logoutConfirmButton.localized,
            cancelButtonTitle: OlsunStrings.cancelButton.localized
        )
        confirmation.onConfirm = {
            self.viewModel?.showLaunchScreen()
            UserDefaultsHelper.setBool(key: .isLoggedIn, value: false)
        }
        confirmation.onCancel = {
        }
        
        window.addSubview(confirmation)
    }
    
    @objc private func toggleLanguage() {
        let current = LocalizationManager.shared.currentLanguage
        let newLang = (current == "az") ? "en" : "az"
        
        LocalizationManager.shared.setLanguage(newLang)
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.reloadRootViewController()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell", for: indexPath) as? MenuTableCell else {
            return UITableViewCell()
        }
        cell.configure(with: menuItems[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.userSelectedMenuItem(at: indexPath.section)
    }
}

extension HomeViewController: UserProfileDelegate {
    func didRequestLogout(type: LogoutType) {
        viewModel?.showLaunchScreen()
    }
}

enum LogoutType {
    case logout
    case delete
}
