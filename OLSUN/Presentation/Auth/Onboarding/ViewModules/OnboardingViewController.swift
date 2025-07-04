//
//  OnboardingViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import UIKit
import SkeletonView

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
    
    private lazy var nextButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.nextButton.localized,
            onAction: { [weak self] in self?.nextTapped() },
            titleSize: DeviceSizeClass.current == .compact ? 16 : 20,
            titleFont: .workSansMedium
        )
        button.addShadow()
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.loginButton.localized,
            onAction: { [weak self] in self?.loginTapped() },
            bgColor: .accentMain,
            titleColor: .primaryHighlight,
            titleSize: DeviceSizeClass.current == .compact ? 16 : 20,
            titleFont: .workSansMedium
        )
        button.addShadow()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.signUpButton.localized,
            onAction: { [weak self] in self?.registerTapped() },
            titleSize: DeviceSizeClass.current == .compact ? 16 : 20,
            titleFont: .workSansMedium
        )
        button.addShadow()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var guestButton: UIButton = {
        let button = UIButton(type: .system)
        let title = OlsunStrings.guestButtonText.localized
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontKeys.workSansRegular.rawValue, size: 16)!,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.black
        ]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        button.addTarget(self, action: #selector(guestLoginTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var pageControl: CustomPageControl = {
        let pageControl = CustomPageControl()
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private var pages: [UIView] = []
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
        view.addSubViews(loadingView, scrollView, pageControl, nextButton, loginButton, registerButton, guestButton)
        view.bringSubviewToFront(loadingView)
        
        configurePages()
        pageControl.numberOfPages = pages.count
    }
    
    fileprivate func configureNavigationBar() {

        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight

        let toggleLangButton = UIBarButtonItem(
            title: LocalizationManager.shared.currentLanguage == "en" ? "EN" : "AZ",
            style: .plain,
            target: self,
            action: #selector(toggleLanguage)
        )
        toggleLangButton.tintColor = .primaryHighlight

        navigationItem.rightBarButtonItems = [toggleLangButton]
    }
    
    override func configureConstraint() {
        loadingView.fillSuperviewSafeAreaLayoutGuide()
        
        let buttonHeight: CGFloat = DeviceSizeClass.current == .compact ? 48 : 52

        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        scrollView.anchorSize(.init(width: 0, height: view.frame.height * 0.65))
        
        pageControl.anchor(
            top: scrollView.bottomAnchor,
            padding: .init(all: 16)
        )
        pageControl.centerXToSuperview()
        
        let nextButtonDist: CGFloat = DeviceSizeClass.current == .compact ? 24 : 80
        nextButton.anchor(
            bottom: view.bottomAnchor,
            padding: .init(all: nextButtonDist)
        )
        nextButton.anchorSize(.init(width: view.frame.width/3 + 12, height: buttonHeight))
        nextButton.centerXToSuperview()
        
        let buttonDist: CGFloat = DeviceSizeClass.current == .compact ? -60 : -80
        loginButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.centerXAnchor,
            padding: .init(top: 0, left: 32, bottom: buttonDist, right: -8)
        )
        loginButton.anchorSize(.init(width: 0, height: buttonHeight))
        
        registerButton.anchor(
            leading: view.centerXAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 8, bottom: buttonDist, right: -32)
        )
        registerButton.anchorSize(.init(width: 0, height: buttonHeight))
        
        let guestButtonDist: CGFloat = DeviceSizeClass.current == .compact ? 20 : 32
        guestButton.anchor(
            bottom: view.bottomAnchor,
            padding: .init(all: guestButtonDist)
        )
        guestButton.centerXToSuperview()
    }

    private func makeFirstPage(title: String, subtitle: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.isSkeletonable = true
        imageView.loadImage(named: "/img/app/onboardingImageFirst.png")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        var size = 0
        if DeviceSizeClass.current == .compact { size = 24 }
        else if DeviceSizeClass.current == .iPad { size = 48 }
        else { size = 26 }
        
        let titleSize: CGFloat = CGFloat(size)
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: FontKeys.futuricaBold.rawValue, size: titleSize)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .primaryHighlight
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        var subSize = 0
        if DeviceSizeClass.current == .compact { subSize = 16 }
        else if DeviceSizeClass.current == .iPad { subSize = 36 }
        else { subSize = 18 }
        
        let subTitleSize: CGFloat = CGFloat(subSize)
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont(name: FontKeys.workSansRegular.rawValue, size: subTitleSize)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .black
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubViews(imageView, titleLabel, subtitleLabel)

        let multiplier: CGFloat = DeviceSizeClass.current == .compact ? 0.35 : 0.4
        imageView.anchor(
            top: container.topAnchor,
            padding: .init(all: 0)
        )
        imageView.centerXToView(to: container)
        imageView.anchorSize(.init(width: view.frame.height*multiplier, height: view.frame.height*multiplier))
        
        titleLabel.anchor(
            top: imageView.bottomAnchor,
            leading: container.leadingAnchor,
            trailing: container.trailingAnchor,
            padding: .init(top: 40, left: 24, bottom: 0, right: -24)
        )
        
        subtitleLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: container.leadingAnchor,
            trailing: container.trailingAnchor,
            padding: .init(top: 20, left: 24, bottom: 0, right: -24)
        )

        return container
    }

    private func makeSecondPage(title: String, subtitle: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.isSkeletonable = true
        imageView.loadImage(named: "/img/app/onboardingImageSecond.png")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        var size = 0
        if DeviceSizeClass.current == .compact { size = 24 }
        else if DeviceSizeClass.current == .iPad { size = 48}
        else { size = 26 }
        
        let titleSize: CGFloat = CGFloat(size)
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: FontKeys.futuricaBold.rawValue, size: titleSize)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .primaryHighlight
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        var subSize = 0
        if DeviceSizeClass.current == .compact { subSize = 16 }
        else if DeviceSizeClass.current == .iPad { subSize = 36 }
        else { subSize = 18 }
        
        let subTitleSize: CGFloat = CGFloat(subSize)
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont(name: FontKeys.workSansRegular.rawValue, size: subTitleSize)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .black
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubViews(imageView, titleLabel, subtitleLabel)

        let multiplier: CGFloat = DeviceSizeClass.current == .compact ? 0.35 : 0.4
        imageView.anchor(
            top: container.topAnchor,
            padding: .init(all: 0)
        )
        imageView.centerXToView(to: container)
        imageView.anchorSize(.init(width: view.frame.height*multiplier, height: view.frame.height*multiplier))
        
        titleLabel.anchor(
            top: imageView.bottomAnchor,
            leading: container.leadingAnchor,
            trailing: container.trailingAnchor,
            padding: .init(top: 40, left: 24, bottom: 0, right: -24)
        )
        
        subtitleLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: container.leadingAnchor,
            trailing: container.trailingAnchor,
            padding: .init(top: 20, left: 24, bottom: 0, right: -24)
        )

        return container
    }

    private func configurePages() {
        let page1 = makeFirstPage(
            title: OlsunStrings.onboardingtitle.localized,
            subtitle:  OlsunStrings.onboardingMessage_First.localized
        )

        let page2 = makeSecondPage(
            title: OlsunStrings.onboardingtitle.localized,
            subtitle:  OlsunStrings.onboardingMessage_Second.localized
        )

        pages = [page1, page2]

        for (index, page) in pages.enumerated() {
            scrollView.addSubview(page)

            NSLayoutConstraint.activate([
                page.topAnchor.constraint(equalTo: scrollView.topAnchor),
                page.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                page.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                page.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * view.frame.width)
            ])
        }

        scrollView.contentSize = CGSize(width: CGFloat(pages.count) * view.bounds.width, height: scrollView.bounds.height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        pageControl.currentPage = pageIndex

        let isLastPage = pageIndex == (pages.count - 1)
        loginButton.isHidden = !isLastPage
        registerButton.isHidden = !isLastPage
        guestButton.isHidden = !isLastPage

        nextButton.isHidden = isLastPage
    }
    

    @objc private func nextTapped() {
        let nextOffset = CGPoint(x: view.frame.width, y: 0)
        scrollView.setContentOffset(nextOffset, animated: true)
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
    
    @objc private func toggleLanguage() {
        let current = LocalizationManager.shared.currentLanguage
        let newLang = (current == "az") ? "en" : "az"
        
        LocalizationManager.shared.setLanguage(newLang)
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.reloadRootViewController()
        }
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
