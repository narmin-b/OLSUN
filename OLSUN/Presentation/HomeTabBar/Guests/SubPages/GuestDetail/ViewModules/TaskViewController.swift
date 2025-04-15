//
//  GuestViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import UIKit

final class GuestViewController: BaseViewController {
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
        let label = ReusableLabel(labelText: "Test",
                                  labelColor: .primaryHighlight,
                                  labelFont: .montserratMedium,
                                  labelSize: 24,
                                  numOfLines: 3
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = ReusableButton(
            title: "",
            onAction: editTaskButtonTapped,
            bgColor: .clear,
        )
        let image = UIImage(named: "editIcon")
        let resizedImage = image?.resizeImage(to: CGSize(width: 24, height: 24))
        button.setImage(resizedImage, for: .normal)
        button.tintColor = .primaryHighlight
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let label = ReusableLabel(labelText: "Deadline:",
                                  labelColor: .black,
                                  labelFont: .montserratMedium,
                                  labelSize: 16,
                                  numOfLines: 3
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = ReusableLabel(labelText: "11.11.1111",
                                  labelColor: .black,
                                  labelFont: .montserratMedium,
                                  labelSize: 16,
                                  numOfLines: 3
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = ReusableButton(
            title: "Daxil ol",
            onAction: cancelTapped,
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
            title: "Hesab yarat",
            onAction: saveTapped,
            titleSize: DeviceSizeClass.current == .compact ? 16 : 20,
            titleFont: .workSansMedium
        )
        button.addShadow()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var statusMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Status", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .secondaryHighlight
        button.layer.cornerRadius = 12
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: -12, bottom: 12, right: 0)
        button.tintColor = .black
        button.showsMenuAsPrimaryAction = true
        button.addRightImage(image: UIImage(systemName: "chevron.down")!, offset: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let viewModel: TaskViewModel?
    let statusOptions = ["Qəbul edib", "Gözləmədə", "Uyğun deyil"]
    
    init(viewModel: TaskViewModel) {
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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.tabBar.isHidden = false
            tabBarController.customTabBarView.isHidden = false
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        setUpTask()
        print(viewModel?.taskItem!)
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
        navigationItem.configureNavigationBar(text: "Planlama")
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, titleLabel, addTaskButton, deadlineLabel, dateLabel)
        view.bringSubviewToFront(loadingView)
        
        

        let menuItems = statusOptions.map { option in
            UIAction(title: option) { [weak self] _ in
                self?.statusMenuButton.setTitle(option, for: .normal)
                print("✅ Selected: \(option)")
            }
        }

        statusMenuButton.menu = UIMenu(title: "", options: .displayInline, children: menuItems)

        view.addSubview(statusMenuButton)
        statusMenuButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 12, left: 16, bottom: 0, right: 0)
        )
        addTaskButton.anchor(
            trailing: view.trailingAnchor,
            padding: .init(all: 16)
        )
        addTaskButton.anchorSize(.init(width: 32, height: 32))
        addTaskButton.centerYToView(to: titleLabel)
        
        deadlineLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 20, left: 16, bottom: 0, right: 0)
        )
        dateLabel.anchor(
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: -16)
        )
        dateLabel.centerYToView(to: deadlineLabel)
        
        statusMenuButton.anchor(
            top: deadlineLabel.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 20, left: 16, bottom: 0, right: 0)
        )
        statusMenuButton.anchorSize(.init(width: view.frame.width/3 + 8, height: 44))
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
    
    fileprivate func setUpTask(){
        titleLabel.text = viewModel?.taskItem?.title
        dateLabel.text = viewModel?.taskItem?.description
    }
    
    @objc fileprivate func editTaskButtonTapped() {
        print(#function)
    }
    
    @objc fileprivate func saveTapped() {
        print(#function)
    }
    
    @objc fileprivate func cancelTapped() {
        print(#function)
    }
}

extension UIButton {
    func addRightImage(image: UIImage, offset: CGFloat) {
        self.setImage(image, for: .normal)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
    }
}
