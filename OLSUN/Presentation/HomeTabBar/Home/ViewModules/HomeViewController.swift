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
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Hazırlıqlar",
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
        MenuItem(iconName: "planningIcon", title: "Planlama", description: "Daha çox məlumat"),
        MenuItem(iconName: "guestsIcon", title: "Qonaqlar", description: "Daha çox məlumat")
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
        
        homeImageView.loadImage(named: "homeImage.png")
    }
    
    override func configureView() {
        configureNavigationBar()
        
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
        homeImageView.anchorSize(.init(width: view.frame.width, height: DeviceSizeClass.current == .compact ? 160 : 200))
        
        titleLabel.anchor(
            top: homeImageView.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 24, left: 16, bottom: 0, right: 0)
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 76),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let logoItem = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = logoItem
        
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "iphone.and.arrow.right.outward"),
            style: .plain,
            target: self,
            action: #selector(logOutTapped)
        )
        editButton.tintColor = .primaryHighlight
        navigationItem.rightBarButtonItem = editButton
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
                }
            }
        }
    }
    
    // MARK: Functions
    @objc private func logOutTapped() {
        viewModel?.showLaunchScreen()
        UserDefaultsHelper.setBool(key: .isLoggedIn, value: false)
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
        viewModel?.userSelectedMenuItem(at: 1 + indexPath.section)
    }
}
