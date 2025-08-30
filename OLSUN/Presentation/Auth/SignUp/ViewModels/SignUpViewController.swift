//
//  SignUpViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import UIKit
import AuthenticationServices

final class SignUpViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
    private lazy var emailLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.emailText.localized,
            labelColor: .black,
            labelFont: .robotoSerifMedium,
            labelSize: 13,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Emailinizi daxil edin",
            placeholderSize: 15,
            placeholderFont: .robotoSerifMedium,
            placeholderColor: .neutral400,
            borderColor: .neutraln200,
            borderWidth: 1
        )
        textfield.textColor = .black
        textfield.font = UIFont(name: "RobotoSerif-Medium", size: 15)
        textfield.delegate = self
        textfield.tintColor = .clear
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        textfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return textfield
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.passwordText.localized,
            labelColor: .black,
            labelFont: .robotoSerifMedium,
            labelSize: 13,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Şifrənizi daxil edin",
            placeholderSize: 15,
            placeholderFont: .robotoSerifMedium,
            placeholderColor: .neutral400,
            borderColor: .neutraln200,
            borderWidth: 1
        )
        
        let toggleButton = UIButton(type: .system)
        toggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        toggleButton.tintColor = .black
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        toggleButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        toggleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        textfield.rightView = toggleButton
        textfield.rightViewMode = .always
        
        textfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textfield.textColor = .black
        textfield.font = UIFont(name: "RobotoSerif-Medium", size: 15)
        textfield.delegate = self
        textfield.isSecureTextEntry = true
        textfield.textColor = .black
        textfield.tintColor = .clear
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var passReqLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.pwLengthText.localized,
            labelColor: .neutral500,
            labelFont: .robotoSerifRegular,
            labelSize: 11
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passUpcaseReqLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.pwUCText.localized,
            labelColor: .neutral500,
            labelFont: .robotoSerifRegular,
            labelSize: 11
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passNumReqLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.pwNumText.localized,
            labelColor: .neutral500,
            labelFont: .robotoSerifRegular,
            labelSize: 11
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passSymbolReqLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.pwSymbolText.localized,
            labelColor: .neutral500,
            labelFont: .robotoSerifRegular,
            labelSize: 11
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordRequirementsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passReqLabel, passUpcaseReqLabel, passNumReqLabel, passSymbolReqLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var signupButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.continueButton.localized,
            onAction: { [weak self] in self?.signupTapped() },
            cornerRad: 16,
            bgColor: .violet300,
            titleSize: DeviceSizeClass.current == .large ? 20 : 16,
            titleFont: .robotoSerifSemiBold,
        )
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.orText.localized,
            labelColor: .neutraln500,
            labelFont: .robotoSerifRegular,
            labelSize: 15,
            numOfLines: 1
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var googleSignInButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(NSAttributedString(string: OlsunStrings.googleLoginText.localized, attributes: [.font: UIFont(name: FontKeys.robotoSerifSemiBold.rawValue, size: 16)!]))
        config.baseForegroundColor = .black
        config.background.backgroundColor = .clear
        config.background.strokeWidth = 1
        config.imagePadding = 4
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 10)
        
        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.googleSignInButtonTapped()
        })
        
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 24
        button.layer.borderColor = UIColor.neutraln200.cgColor
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        button.tintColor = .black
        button.contentHorizontalAlignment = .center
        
        let image = UIImage(named: "googleLogo")
        let resizedImage = image?.resizeImage(to: CGSize(width: 44, height: 44))
        button.setImage(resizedImage, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appleSignInButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(NSAttributedString(string: OlsunStrings.appleLoginText.localized, attributes: [.font: UIFont(name: FontKeys.robotoSerifSemiBold.rawValue, size: 16)!]))
        config.baseForegroundColor = .black
        config.background.backgroundColor = .clear
        config.background.strokeWidth = 1
        config.imagePadding = 12
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 24)
        
        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.handleAppleLogin()
        })
        
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 24
        button.layer.borderColor = UIColor.neutraln200.cgColor
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        button.tintColor = .black
        button.contentHorizontalAlignment = .center
        
        let image = UIImage(named: "appleLogo")
        let resizedImage = image?.resizeImage(to: CGSize(width: 22, height: 26))
        button.setImage(resizedImage, for: .normal)
        
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
    
    private let viewModel: SignUpViewModel?
    
    init(viewModel: SignUpViewModel) {
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func removeErrorBorders() {
        emailTextField.layer.borderColor = UIColor.neutraln200.cgColor
        emailTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.neutraln200.cgColor
        passwordTextField.layer.borderWidth = 1
    }
   
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem(
            image: UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
        navigationItem.configureNavigationBar(text: "Qeydiyyat")
        navigationItem.leftBarButtonItem = backItem
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, emailLabel, emailTextField, passwordLabel, passwordTextField, passwordRequirementsStack, signupButton, orLabel, googleSignInButton, appleSignInButton)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
                
        let topDist: CGFloat = DeviceSizeClass.current == .compact ? 48 : 102
        emailLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: topDist, left: 16, bottom: 0, right: 0)
        )
        emailTextField.anchor(
            top: emailLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 6, left: 16, bottom: 0, right: -16)
        )
        emailTextField.centerXToSuperview()
        emailTextField.anchorSize(.init(width: 0, height: 44))
        
        passwordLabel.anchor(
            top: emailTextField.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 12, left: 16, bottom: 0, right: 0)
        )
        passwordTextField.anchor(
            top: passwordLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 6, left: 16, bottom: 0, right: -16)
        )
        passwordTextField.centerXToSuperview()
        passwordTextField.anchorSize(.init(width: 0, height: 44))
        
        passwordRequirementsStack.anchor(
            top: passwordTextField.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 6, left: 32, bottom: 0, right: 0)
        )
  
        let buttonHeight: CGFloat = DeviceSizeClass.current == .compact ? 48 : 56
        signupButton.anchor(
            top: passwordRequirementsStack.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 80, left: 20, bottom: 0, right: -20)
        )
        signupButton.anchorSize(.init(width: 0, height: buttonHeight))
        
        appleSignInButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 32, bottom: -75, right: -32)
        )
        appleSignInButton.centerXToSuperview()
        appleSignInButton.anchorSize(.init(width: 0, height: 54))
        
        googleSignInButton.anchor(
            leading: view.leadingAnchor,
            bottom: appleSignInButton.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 32, bottom: -8, right: -32)
        )
        googleSignInButton.centerXToSuperview()
        googleSignInButton.anchorSize(.init(width: 0, height: 54))
        
        orLabel.anchor(
            bottom: googleSignInButton.topAnchor,
            padding: .init(all: 16)
        )
        orLabel.centerXToSuperview()
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
    
    @objc func googleSignInButtonTapped() {
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
    
    @objc fileprivate func signupTapped() {
        checkInputRequirements()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSignupButton()
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
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func checkInputRequirements() {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        checkErrorBorders(email: email, password: password)
        if email.isValidEmail() && password.isValidPassword() {
            let loggedUser = LoginDataModel(email: email, password: password)
            viewModel?.showShowLaunchScreen(auth: .local, loginUser: loggedUser, googleUser: nil)
        }
    }
    
    fileprivate func checkErrorBorders(email: String, password: String) {
        if !email.isValidEmail() {
            emailTextField.errorBorderOn()
        } else {
            emailTextField.layer.borderColor = UIColor.neutraln200.cgColor
            emailTextField.layer.borderWidth = 1
        }
        if !password.isValidPassword() {
            if password.isValidPasswordMask() {
                passReqLabel.textColor = .black
            } else {
                passReqLabel.textColor = .red
            }
            if password.doesContainDigit() {
                passNumReqLabel.textColor = .black
            } else {
                passNumReqLabel.textColor = .red
            }
            if password.doesContainUppercase() {
                passUpcaseReqLabel.textColor = .black
            } else {
                passUpcaseReqLabel.textColor = .red
            }
            if password.isValidPassword() {
                passSymbolReqLabel.textColor = .black
            } else {
                passSymbolReqLabel.textColor = .red
            }
            passwordTextField.errorBorderOn()
        } else {
            passwordTextField.layer.borderColor = UIColor.neutraln200.cgColor
            passwordTextField.layer.borderWidth = 1
        }
    }
    
    fileprivate func checkPassWordRequirements() {
        let passwordText = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if passwordText.isValidPasswordMask() {
                passReqLabel.textColor = .reqGreen
            } else {
                passReqLabel.textColor = .red
            }
            if passwordText.doesContainDigit() {
                passNumReqLabel.textColor = .reqGreen
            } else {
                passNumReqLabel.textColor = .red
            }
            if passwordText.doesContainUppercase() {
                passUpcaseReqLabel.textColor = .reqGreen
            } else {
                passUpcaseReqLabel.textColor = .red
            }
            if passwordText.isValidPassword() {
                passSymbolReqLabel.textColor = .reqGreen
            } else {
                passSymbolReqLabel.textColor = .red
            }
        
    }
    
    fileprivate func textfieldCleaning() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    fileprivate func updateSignupButton() {
        let isEmailEmpty = emailTextField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.isEmpty ?? true

        if isEmailEmpty || isPasswordEmpty {
            signupButton.backgroundColor = .violet300
            signupButton.isUserInteractionEnabled = false
        } else {
            signupButton.backgroundColor = .violet700
            signupButton.isUserInteractionEnabled = true
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateSignupButton()
        if textField == passwordTextField {
            checkPassWordRequirements()
        }
    }
}
