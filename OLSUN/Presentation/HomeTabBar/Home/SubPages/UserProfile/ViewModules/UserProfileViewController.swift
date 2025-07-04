//
//  UserProfileViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 11.05.25.
//

import UIKit

protocol UserProfileDelegate: AnyObject {
    func didRequestLogout(type: LogoutType)
}

final class UserProfileViewController: BaseViewController {
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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadPage), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = ReusableButton(
            title: "",
            onAction: { [weak self] in self?.editProfileButtonTapped() },
            bgColor: .clear,
        )
        button.accessibilityIdentifier = "editProfileButton"
        let image = UIImage(named: "editProfile")
        let resizedImage = image?.resizeImage(to: CGSize(width: 24, height: 24))
        button.setImage(resizedImage, for: .normal)
        button.tintColor = .primaryHighlight
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var userInfoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ProfileInfoCell.self, forCellReuseIdentifier: ProfileInfoCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: -16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.logoutButton.localized,
            onAction: { [weak self] in self?.logoutButtonTapped() },
            titleSize: DeviceSizeClass.current == .large ? 20 : 16,
            titleFont: .workSansMedium,
        )
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var deleteAccountButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.deleteAccButton.localized,
            onAction: { [weak self] in self?.deleteAccountTapped() },
            bgColor: .warningRed,
            titleSize: DeviceSizeClass.current == .large ? 20 : 16,
            titleFont: .workSansMedium
        )
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var guestLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Davam etmək üçün hesab yaradın",
            labelColor: .primaryHighlight,
            labelFont: .workSansBold,
            labelSize: 28,
            numOfLines: 0
        )
        label.accessibilityIdentifier = "guestTitleLabel"
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createAccButton: UIButton = {
        let button = ReusableButton(
            title: "Hesab yarat",
            onAction: { [weak self] in self?.createAccountTapped() },
            titleSize: DeviceSizeClass.current == .large ? 20 : 16,
            titleFont: .workSansMedium,
        )
        button.addShadow()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: Configurations
    private let viewModel: UserProfileViewModel?
    private var bottomBorder: UIView?
    weak var logoutDelegate: UserProfileDelegate?
    var userInfo: UserInfoDataModel?
    var data: [ProfileInfoDisplayItem] = []
    
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        viewModel?.requestCallback = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.tabBar.isHidden = true
            tabBarController.customTabBarView.isHidden = true
        }
        
        if viewModel?.loginType == "user" {
            showUserProfile()
            viewModel?.getUserInfo()
        } else {
            showGuestScreen()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.tabBar.isHidden = false
            tabBarController.customTabBarView.isHidden = false
        }
        
        bottomBorder?.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
      
        Logger.debug("id: \(KeychainHelper.getString(key: .userID) ?? "")")
        userInfoTableView.reloadData()

    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, /*editProfileButton,*/ userInfoTableView, logoutButton, deleteAccountButton, guestLabel, createAccButton)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperviewSafeAreaLayoutGuide()
      
        userInfoTableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: logoutButton.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 12, left: 0, bottom: -12, right: 0)
        )
        
        let buttonHeight: CGFloat = DeviceSizeClass.current == .compact ? 48 : 52
        
        logoutButton.anchor(
            leading: view.leadingAnchor,
            bottom: deleteAccountButton.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: -12, right: -16)
        )
        logoutButton.anchorSize(.init(width: 0, height: buttonHeight))
        
        deleteAccountButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: -16, right: -16)
        )
        deleteAccountButton.anchorSize(.init(width: 0, height: buttonHeight))
        
        guestLabel.centerXToSuperview()
        guestLabel.centerYToSuperview()
        guestLabel.anchor(
                leading: view.leadingAnchor,
                trailing: view.trailingAnchor,
                padding: .init(top: 0, left: 12, bottom: 0, right: -12)
            )
            
        
        createAccButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: -16, right: -16)
        )
        createAccButton.anchorSize(.init(width: 0, height: buttonHeight))
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
        navigationItem.configureNavigationBar(text: OlsunStrings.profileText.localized)
        
        let border = UIView()
        border.backgroundColor = .lightGray.withAlphaComponent(0.5)
        border.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.addSubview(border)
        
        border.anchorSize(.init(width: 0, height: 4))
        border.anchor(
            leading: navigationController!.navigationBar.leadingAnchor,
            bottom: navigationController!.navigationBar.bottomAnchor,
            trailing: navigationController!.navigationBar.trailingAnchor,
            padding: .init(all: 0)
        )
        
        self.bottomBorder = border
    }
    
    private func configureViewModel() {
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch state {
                case .refreshError(let message):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.refreshControl.endRefreshing()
                        self.showMessage(title: "Error", message: message)
                    }
                case .loading:
                    self.loadingView.startAnimating()
                case .loaded:
                    self.loadingView.stopAnimating()
                case .success:
                    self.refreshControl.endRefreshing()
                    if let user = self.viewModel?.user {
                        self.data = user.toDisplayItems()
                        self.userInfoTableView.reloadData()
                    }
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                case .deleteSuccess:
                    self.showMessage(title: OlsunStrings.updateSuccessText.localized, message: OlsunStrings.accDelete_Success.localized)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.logoutDelegate?.didRequestLogout(type: .delete)
                    }
                }
            }
        }
    }
    
    // MARK: Functions
    func showDeleteAccountAlert() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let confirmation = ConfirmationView(frame: UIScreen.main.bounds)
        confirmation.configure(
            title: OlsunStrings.confirmationTitle.localized,
            message: OlsunStrings.accDelete_Message.localized,
            confirmButtonTitle: OlsunStrings.accDeleteWarningButton.localized,
            cancelButtonTitle: OlsunStrings.cancelButton.localized
        )
        confirmation.onConfirm = {
            self.viewModel?.deleteAccount()
            UserDefaultsHelper.setBool(key: .isLoggedIn, value: false)
        }
        confirmation.onCancel = {
        }
        
        window.addSubview(confirmation)
    }
    
    func showLogoutAlert() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let confirmation = ConfirmationView(frame: UIScreen.main.bounds)
        confirmation.configure(
            title: OlsunStrings.confirmationTitle.localized,
            message: OlsunStrings.logoutAcc_Message.localized,
            confirmButtonTitle: OlsunStrings.logoutConfirmButton.localized,
            cancelButtonTitle: OlsunStrings.cancelButton.localized
        )
        confirmation.onConfirm = {
            self.logoutDelegate?.didRequestLogout(type: .logout)
            UserDefaultsHelper.setBool(key: .isLoggedIn, value: false)
        }
        confirmation.onCancel = {
        }
        
        window.addSubview(confirmation)
    }
    
    @objc fileprivate func editProfileButtonTapped() {
        if NetworkMonitor.shared.isConnected {
            //            viewModel?.showAddTaskVC()
        } else {
            self.showMessage(title: OlsunStrings.networkError.localized, message: OlsunStrings.networkError_Message.localized)
        }
    }
    
    @objc fileprivate func reloadPage() {
    }
    
    @objc fileprivate func deleteAccountTapped() {
        showDeleteAccountAlert()
    }
    
    @objc fileprivate func logoutButtonTapped() {
        showLogoutAlert()
    }
    
    @objc fileprivate func createAccountTapped() {
        viewModel?.showSignupScreen()
    }
    
    fileprivate func showUserProfile() {
        editProfileButton.isHidden = false
        userInfoTableView.isHidden = false
        logoutButton.isHidden = false
        deleteAccountButton.isHidden = false
        guestLabel.isHidden = true
        createAccButton.isHidden = true
    }
    
    fileprivate func showGuestScreen() {
        editProfileButton.isHidden = true
        userInfoTableView.isHidden = true
        logoutButton.isHidden = true
        deleteAccountButton.isHidden = true
        guestLabel.isHidden = false
        createAccButton.isHidden = false
    }
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoCell.identifier, for: indexPath) as? ProfileInfoCell else {
            return UITableViewCell()
        }
        
        let item = data[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(title: item.title, value: item.value, showSeparator: indexPath.row != data.count - 1)
        return cell
    }
}
