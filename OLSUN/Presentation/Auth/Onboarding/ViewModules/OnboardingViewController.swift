//
//  OnboardingViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "onboardingImage"))
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        
        var size = 32
        if flag { size = 28 }

        let regularFont = UIFont(name: FontKeys.workSansMedium.rawValue, size: CGFloat(size))
        let boldFont = UIFont(name: FontKeys.workSansBold.rawValue, size: CGFloat(size))

        let text = "Find all the needed services for your "
        let boldText = "special day"

        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: regularFont, .foregroundColor: UIColor.primaryHighlight])
        let boldAttributedString = NSAttributedString(string: boldText, attributes: [.font: boldFont, .foregroundColor: UIColor.primaryHighlight])

        attributedString.append(boldAttributedString)

        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = ReusableButton(
            title: "Login",
            onAction: loginTapped,
            titleFont: .interBold
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = ReusableButton(
            title: "Register",
            onAction: registerTapped,
            bgColor: .backgroundMain,
            titleColor: .primaryHighlight,
            titleFont: .interBold,
            borderColor: .primaryHighlight,
            borderWidth: 2
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var guestButton: UIButton = {
        let button = UIButton(type: .system)

        let title = "Continue as a guest"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontKeys.interSemiBold.rawValue, size: 16),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.black.withAlphaComponent(0.7)
        ]

        let attributedString = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(guestLoginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewModel: SignUpViewModel?
    let flag = UIScreen.main.bounds.width <= 375
    
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
        print(UIScreen.main.bounds.width)
        print(flag)
    }
    
    fileprivate func setUpBackground() {
        let backgroundView = OnboardingViewBackground(frame: view.bounds)
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
        view.addSubViews(loadingView, imageView, titleLabel, loginButton, registerButton, guestButton)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        imageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: -4, left: 16, bottom: 0, right: 0)
        )
        if flag/*UIScreen.main.bounds.width <= 375*/ {
            imageView.anchorSize(.init(width: view.frame.width * 0.65, height: (view.frame.width * 0.75)*447/357))
        } else {
            imageView.anchorSize(.init(width: view.frame.width * 0.85, height: (view.frame.width * 0.75)*447/357))
        }
        
        var size = 40
        if flag { size = 28 }

        titleLabel.anchor(
            leading: view.leadingAnchor,
            bottom: loginButton.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0/*62*/, left: 44, bottom: -CGFloat(size), right: -44)
        )
        
        titleLabel.centerXToSuperview()
        
        loginButton.anchor(
            leading: view.leadingAnchor,
            bottom: guestButton.topAnchor,
            trailing: view.centerXAnchor,
            padding: .init(top: 0, left: 16, bottom: -12, right: -8)
        )
        loginButton.anchorSize(.init(width: 0, height: 44))
        
        registerButton.anchor(
            leading: view.centerXAnchor,
            bottom: guestButton.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0/*28*/, left: 8, bottom: -12, right: -16)
        )
        registerButton.anchorSize(.init(width: 0, height: 44))
        
        guestButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 24, bottom: -20, right: -24)
        )
        guestButton.anchorSize(.init(width: 0, height: 44))
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
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    @objc fileprivate func loginTapped() {
        print(#function)
    }
    
    @objc fileprivate func registerTapped() {
        print(#function)
    }
    
    @objc fileprivate func guestLoginTapped() {
        print(#function)
    }
}
