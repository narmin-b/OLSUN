//
//  LoginViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//
//
//struct AppleUser {
//    let id: String
//    let name: String
//    let email: String
//    let token: String
//}

import UIKit
import GoogleSignIn
import AuthenticationServices

final class LoginViewController: BaseViewController {
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
            labelText: OlsunStrings.loginVC_Message.localized,
            labelColor: .primaryHighlight,
            labelFont: .futuricaBold,
            labelSize: 32,
            numOfLines: 2
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.emailText.localized,
            labelColor: .black,
            labelFont: .workSansRegular,
            labelSize: DeviceSizeClass.current == .large ? 20 : 16,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "")
        textfield.textColor = .black
        textfield.tintColor = .clear
        textfield.addShadow()
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.passwordText.localized,
            labelColor: .black,
            labelFont: .workSansRegular,
            labelSize: DeviceSizeClass.current == .large ? 20 : 16,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textfield = ReusableTextField(placeholder: "")
        
        let toggleButton = UIButton(type: .system)
        toggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        toggleButton.tintColor = .black
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        toggleButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        toggleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        textfield.rightView = toggleButton
        textfield.rightViewMode = .always
        
        textfield.isSecureTextEntry = true
        textfield.textColor = .black
        textfield.tintColor = .clear
        textfield.addShadow()
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var loginButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.continueButton.localized,
            onAction: { [weak self] in self?.loginTapped() },
            titleSize: DeviceSizeClass.current == .large ? 20 : 16,
            titleFont: .workSansMedium,
        )
        button.addShadow()
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var seperatorStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [line1View, orLabel, line2View])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var line1View: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.anchorSize(.init(width: 0, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var line2View: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.anchorSize(.init(width: 0, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var orLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.orText.localized,
            labelColor: .primaryHighlight,
            labelFont: .futuricaBold,
            labelSize: 20,
            numOfLines: 1
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var googleLoginButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(NSAttributedString(string: OlsunStrings.googleLoginText.localized, attributes: [.font: UIFont(name: FontKeys.workSansSemiBold.rawValue, size: 16)!]))
        config.baseForegroundColor = .black
        config.background.backgroundColor = .clear
        config.background.strokeWidth = 1
        config.imagePadding = 4
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
        
        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.googleLoginButtonTapped()
        })
        
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 6
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.tintColor = .black
        button.addShadow()
        button.contentHorizontalAlignment = .center
        
        let image = UIImage(named: "googleLogo")
        let resizedImage = image?.resizeImage(to: CGSize(width: 26, height: 26))
        button.setImage(resizedImage, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .white)
        button.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        
        button.layer.cornerRadius = 6
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var doneToolBar: UIToolbar = {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        return keyboardToolbar
    }()
    
    private let viewModel: LoginViewModel?
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        viewModel?.requestCallback = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isKeepLoggedIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, titleLabel, emailLabel, emailTextField, passwordLabel, passwordTextField, loginButton, seperatorStackView, googleLoginButton, appleLoginButton)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        let topConst: CGFloat = DeviceSizeClass.current == .compact ? 0 : 16
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: topConst, left: 24, bottom: 0, right: -24)
        )
        
        let textFieldHeight: CGFloat = DeviceSizeClass.current == .compact ? 32 : 36
        let textFieldDist: CGFloat = DeviceSizeClass.current == .compact ? 12 : 16
        
        let topDist: CGFloat = DeviceSizeClass.current == .compact ? 36 : 60
        emailLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: topDist, left: 32, bottom: 0, right: 0)
        )
        emailTextField.anchor(
            top: emailLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 32, bottom: 0, right: -32)
        )
        emailTextField.centerXToSuperview()
        emailTextField.anchorSize(.init(width: 0, height: textFieldHeight))
        
        passwordLabel.anchor(
            top: emailTextField.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: textFieldDist, left: 32, bottom: 0, right: 0)
        )
        passwordTextField.anchor(
            top: passwordLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 32, bottom: 0, right: -32)
        )
        passwordTextField.centerXToSuperview()
        passwordTextField.anchorSize(.init(width: 0, height: textFieldHeight))
        
        let buttonHeight: CGFloat = DeviceSizeClass.current == .compact ? 48 : 52
        loginButton.anchor(
            top: passwordTextField.bottomAnchor,
            
            padding: .init(all: 44)
        )
        loginButton.centerXToSuperview()
        loginButton.anchorSize(.init(width: view.frame.width/3 + 12, height: buttonHeight))
        
        let seperatorDist: CGFloat = DeviceSizeClass.current == .compact ? 72 : 68
        seperatorStackView.centerXToSuperview()
        seperatorStackView.anchorSize(.init(width: 0, height: 20))
        seperatorStackView.anchor(
            top: loginButton.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: seperatorDist, left: 32, bottom: 0, right: -32)
        )
        orLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        orLabel.centerYToView(to: seperatorStackView)
        line1View.centerYToView(to: seperatorStackView)
        line2View.centerYToView(to: seperatorStackView)
        
        NSLayoutConstraint.activate([
            line1View.widthAnchor.constraint(equalTo: seperatorStackView.widthAnchor, multiplier: 0.4),
            line2View.widthAnchor.constraint(equalTo: seperatorStackView.widthAnchor, multiplier: 0.4),
        ])
        
        let googleDist: CGFloat = DeviceSizeClass.current == .compact ? 40 : 44
        googleLoginButton.anchor(
            top: seperatorStackView.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: googleDist, left: 32, bottom: 0, right: -32)
        )
        googleLoginButton.centerXToSuperview()
        googleLoginButton.anchorSize(.init(width: 0, height: 44))
        
        appleLoginButton.anchor(
            top: googleLoginButton.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 12, left: 32, bottom: 0, right: -32)
        )
        appleLoginButton.centerXToSuperview()
        appleLoginButton.anchorSize(.init(width: 0, height: 44))
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
                case .success:
                    UserDefaultsHelper.setBool(key: .isLoggedIn, value: true)
                    self.viewModel?.showHomeTabBar()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                case .registerSuccess:
                    UserDefaultsHelper.setBool(key: .isLoggedIn, value: true)
                    self.showMessage(
                        title: OlsunStrings.registerSuccessText.localized,
                        message: OlsunStrings.registerSuccess_Message.localized
                    ) {
                        self.viewModel?.showHomeTabBar()
                    }
                }
            }
        }
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        let wasFirstResponder = passwordTextField.isFirstResponder
        let currentText = passwordTextField.text
        
        passwordTextField.isSecureTextEntry.toggle()
        
        passwordTextField.text = nil
        passwordTextField.text = currentText
        
        let iconName = passwordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        sender.setImage(UIImage(systemName: iconName), for: .normal)
        
        if wasFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    @objc func googleLoginButtonTapped() {
        print(#function)
        GoogleAuthManager.shared.signIn(from: self) { result in
            switch result {
            case .success(let googleUser):
                let loggedUser = SingInUser(
                    name: googleUser.name,
                    email: googleUser.email,
                    idToken: googleUser.idToken,
                    appleID: nil
                )
                self.viewModel?.googleEmailCheck(user: loggedUser)
            case .failure(let error):
                Logger.debug("❌ Google Sign-In failed: \(error.localizedDescription)")
            }
        }
    }
    
    @objc fileprivate func loginTapped() {
        checkInputRequirements()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func handleAppleLogin() {
        AppleAuthManager.shared.signIn { result in
            switch result {
            case .success(let user):
                self.viewModel?.appleEmailCheck(user: user)
            case .failure(let error):
                print("Apple Sign In failed: \(error)")
            }
        }
    }
    
    fileprivate func removeErrorBorder() {
        emailTextField.borderOff()
        passwordTextField.borderOff()
    }
    
    fileprivate func checkInputRequirements() {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        checkErrorBorders(email: email, password: password)
        
        if email.isValidEmail() && password.isValidPassword() {
            let user = LoginDataModel(email: email, password: password)
            
            viewModel?.logInUser(user: user)
        }
    }
    
    fileprivate func checkErrorBorders(email: String, password: String) {
        if !email.isValidEmail() {
            emailTextField.errorBorderOn()
        } else {
            emailTextField.borderOff()
        }
        if !password.isValidPassword() {
            passwordTextField.errorBorderOn()
        } else {
            passwordTextField.borderOff()
        }
    }
    
    fileprivate func textfieldCleaning() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}
