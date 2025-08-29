//
//  OnboardingViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController, UIScrollViewDelegate {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .violet900,
            labelFont: .robotoSerifBold,
            labelSize: DeviceSizeClass.current == .compact ? 28 : 32,
            numOfLines: 3
        )
        let text = "OLSUN"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: 10.0, range: NSRange(location: 0, length: text.count))

        label.attributedText = attributedString
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.loginButton.localized,
            onAction: { [weak self] in self?.loginTapped() },
            cornerRad: 22,
            bgColor: .violet950,
            titleColor: .white,
            titleSize: 13,
            titleFont: .robotoSerifMedium
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.signUpButton.localized,
            onAction: { [weak self] in self?.registerTapped() },
            cornerRad: 22,
            bgColor: .clear,
            titleColor: .violet950,
            titleSize: 13,
            titleFont: .robotoSerifMedium,
            borderColor: .violet950,
            borderWidth: 2
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var guestButton: UIButton = {
        let button = UIButton(type: .system)
        let title = OlsunStrings.guestButtonText.localized
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontKeys.robotoSerifRegular.rawValue, size: 15)!,
            .foregroundColor: UIColor.neutraln500
        ]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        button.addTarget(self, action: #selector(guestLoginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deviceClass = DeviceSizeClass.current
    private let flag = UIScreen.main.bounds.width <= 375
    
    private let viewModel: OnboardingViewModel?
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        UserDefaultsHelper.setString(key: .loginType, value: "")
        KeychainHelper.setString("", key: .userID)
    }
    
    override func configureView() {
        configureNavigationBar()
        view.backgroundColor = .white
        view.addSubViews(loadingView, titleLabel, loginButton, registerButton, guestButton)
        view.bringSubviewToFront(loadingView)
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
    }
    
    override func configureConstraint() {
        loadingView.fillSuperviewSafeAreaLayoutGuide()
        
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            padding: .init(all: 66)
        )
        titleLabel.centerXToSuperview()
        
        let guestButtonDist: CGFloat = DeviceSizeClass.current == .compact ? 20 : 32
        guestButton.anchor(
            bottom: view.bottomAnchor,
            padding: .init(all: guestButtonDist)
        )
        guestButton.centerXToSuperview()
        
        loginButton.anchor(
            leading: view.centerXAnchor,
            bottom: guestButton.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 8, bottom: -12, right: -16)
        )
        loginButton.anchorSize(.init(width: 0, height: 44))
        
        registerButton.anchor(
            leading: view.leadingAnchor,
            bottom: guestButton.topAnchor,
            trailing: view.centerXAnchor,
            padding: .init(top: 0, left: 16, bottom: -12, right: -8)
        )
        registerButton.anchorSize(.init(width: 0, height: 44))
    }
    
    @objc private func loginTapped() {
        viewModel?.showLoginScreen()
    }
    
    @objc private func registerTapped() {
        viewModel?.showShowSignUpScreen()
    }
    
    @objc private func guestLoginTapped() {
        viewModel?.guestLogin()
    }
    
    private func configureViewModel() {
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .loading: break
                case .loaded: break
                case .success:
                    UserDefaultsHelper.setBool(key: .isLoggedIn, value: true)
                    UserDefaultsHelper.setString(key: .loginType, value: LoginType.guest.rawValue)
                    self.viewModel?.showHomeTabBar()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
}
