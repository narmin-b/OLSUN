//
//  SignUpViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import UIKit

final class SignUpViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Create an  account to use our services",
            labelColor: .primaryHighlight,
            labelFont: .workSansBold,
            labelSize: 32,
            numOfLines: 3
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Email"
        )
        textfield.textColor = .black
        textfield.tintColor = .black
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Password"
        )
        
        let rightIcon = UIImageView(image: UIImage(systemName: "eye.fill"))
        rightIcon.tintColor = .black
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: rightIcon.frame.height))
        rightIcon.frame = CGRect(x: -8, y: 0, width: rightIcon.frame.width, height: rightIcon.frame.height)
        rightPaddingView.addSubview(rightIcon)
        
        textfield.rightView = rightPaddingView
        textfield.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        rightIcon.isUserInteractionEnabled = true
        rightIcon.addGestureRecognizer(tapGestureRecognizer)
        
        textfield.isSecureTextEntry = true
        textfield.inputAccessoryView = doneToolBar
        textfield.textColor = .black
        textfield.tintColor = .black
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var loginButton: UIButton = {
        let button = ReusableButton(
            title: "Create Account",
            onAction: loginTapped,
            titleFont: .interSemiBold
        )
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
            labelText: "or",
            labelColor: .black,
            labelFont: .interLight,
            labelSize: 12,
            numOfLines: 1
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var googleLoginButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(NSAttributedString(string: "Continue with Google", attributes: [.font: UIFont(name: FontKeys.interSemiBold.rawValue, size: 16)]))
        config.baseForegroundColor = .black
        config.background.backgroundColor = .clear
        config.background.strokeColor = .black
        config.background.strokeWidth = 1
        config.imagePadding = 12
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)

        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.googleLoginButtonTapped()
        })

        button.clipsToBounds = true
        button.tintColor = .white
        button.contentHorizontalAlignment = .center
        
        let image = UIImage(named: "googleLogo")
        let resizedImage = image?.resizeImage(to: CGSize(width: 24, height: 24))
        button.setImage(resizedImage, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(NSAttributedString(string: "Continue with Apple", attributes: [.font: UIFont(name: FontKeys.interSemiBold.rawValue, size: 16)]))
        config.baseForegroundColor = .black
        config.background.backgroundColor = .clear
        config.background.strokeColor = .black
        config.background.strokeWidth = 1
        config.imagePadding = 12
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)

        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.googleLoginButtonTapped()
        })

        button.clipsToBounds = true
        button.tintColor = .white
        button.contentHorizontalAlignment = .center
        
        let image = UIImage(named: "appleLogo")
        let resizedImage = image?.resizeImage(to: CGSize(width: 16, height: 16))
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
        keyboardToolbar.translatesAutoresizingMaskIntoConstraints = true
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
    
    private var isKeepLoggedIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    fileprivate func setUpBackground() {
        let backgroundView = GeometricBackgroundView(frame: view.bounds)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)

        backgroundView.fillSuperview()
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
    }
    
    override func configureView() {
        setUpBackground()
        configureNavigationBar()
        
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, titleLabel, emailTextField, passwordTextField, loginButton, seperatorStackView, googleLoginButton, appleLoginButton)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        if view.frame.height < 700 {
            titleLabel.anchor(
                top: view.safeAreaLayoutGuide.topAnchor,
                leading: view.leadingAnchor,
                trailing: view.trailingAnchor,
                padding: .init(top: 32, left: 52, bottom: 0, right: -52)
            )
        } else {
            titleLabel.anchor(
                top: view.safeAreaLayoutGuide.topAnchor,
                leading: view.leadingAnchor,
                trailing: view.trailingAnchor,
                padding: .init(top: 60, left: 52, bottom: 0, right: -52)
            )
        }
        
        titleLabel.centerXToSuperview()
        
        emailTextField.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 60, left: 32, bottom: 0, right: -32)
        )
        emailTextField.centerXToSuperview()
        emailTextField.anchorSize(.init(width: 0, height: 44))
        
        passwordTextField.anchor(
            top: emailTextField.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 32, bottom: 0, right: -32)
        )
        passwordTextField.centerXToSuperview()
        passwordTextField.anchorSize(.init(width: 0, height: 44))
        
        loginButton.anchor(
            top: passwordTextField.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 32, bottom: 0, right: -32)
        )
        loginButton.centerXToSuperview()
        loginButton.anchorSize(.init(width: 0, height: 44))
        
        seperatorStackView.centerXToSuperview()
        seperatorStackView.anchorSize(.init(width: 0, height: 12))
        seperatorStackView.anchor(
            top: loginButton.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 16, left: 32, bottom: 0, right: -32)
        )
        orLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        orLabel.anchorSize(.init(width: 24, height: 0))

        
        NSLayoutConstraint.activate([
            line1View.widthAnchor.constraint(equalTo: seperatorStackView.widthAnchor, multiplier: 0.4),
            line2View.widthAnchor.constraint(equalTo: seperatorStackView.widthAnchor, multiplier: 0.4),
            ])
        
        googleLoginButton.anchor(
            top: seperatorStackView.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 32, bottom: 0, right: -32)
        )
        googleLoginButton.centerXToSuperview()
        googleLoginButton.anchorSize(.init(width: 0, height: 44))
        
        appleLoginButton.anchor(
            top: googleLoginButton.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 32, bottom: 0, right: -32)
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
                    print(#function)
//                    self.viewModel?.startHomeScreen()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    @objc fileprivate func imageTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as? UIImageView
        
        tappedImage?.image = UIImage(systemName: passwordTextField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill")
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func googleLoginButtonTapped() {
        print(#function)
    }
    
    @objc func appleLoginButtonTapped() {
        print(#function)
    }
    
    @objc fileprivate func loginTapped() {
        print(#function)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
