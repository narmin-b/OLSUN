//
//  PlanningViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import UIKit

final class PlanningViewController: BaseViewController {
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
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.planningVC_Title.localized,
            labelColor: .primaryHighlight,
            labelFont: .montserratMedium,
            labelSize: 24,
            numOfLines: 1
        )
        label.accessibilityIdentifier = "planningTitleLabel"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = ReusableButton(
            title: "",
            onAction: { [weak self] in self?.addTaskButtonTapped() },
            bgColor: .clear,
        )
        button.accessibilityIdentifier = "addTaskButton"
        let image = UIImage(systemName: "plus")
        let resizedImage = image?.resizeImage(to: CGSize(width: 24, height: 24))
        button.setImage(resizedImage, for: .normal)
        button.tintColor = .primaryHighlight
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tasksTableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(ListTableCell.self, forCellReuseIdentifier: "TasksTableCell")
        tableview.separatorStyle = .none
        tableview.backgroundColor = .clear
        tableview.refreshControl = refreshControl
        tableview.accessibilityIdentifier = "tasksTableView"
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    // MARK: Configurations
    private let viewModel: PlanningViewModel?
    
    init(viewModel: PlanningViewModel) {
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
        viewModel?.getAllTasks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        Logger.debug("id: \(KeychainHelper.getString(key: .userID) ?? "")")
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, titleLabel, addTaskButton, tasksTableView)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperviewSafeAreaLayoutGuide()
        
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
        
        tasksTableView.anchor(
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
        navigationItem.configureNavigationBar(text: OlsunStrings.planningText.localized)
        
        let profileButton = UIBarButtonItem(
            image: UIImage(named: "profile"),
            style: .plain,
            target: self,
            action: #selector(profileTabClicked)
        )
        
        profileButton.tintColor = .primaryHighlight
        
        navigationItem.rightBarButtonItems = [profileButton]
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
                    self.tasksTableView.reloadData()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    // MARK: Functions
    @objc fileprivate func addTaskButtonTapped() {
        if NetworkMonitor.shared.isConnected {
            viewModel?.showAddTaskVC()
        } else {
            self.showMessage(title: OlsunStrings.networkError.localized, message: OlsunStrings.networkError_Message.localized)
        }
    }
    
    @objc fileprivate func reloadPage() {
        viewModel?.refreshAllTasks()
    }
    
    @objc private func profileTabClicked() {
        viewModel?.showProfileScreen()
    }
}

extension PlanningViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.taskList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTableCell", for: indexPath) as? ListTableCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel?.taskList[indexPath.section] ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0), itemName: .task)
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
        viewModel?.taskSelected(taskItem: viewModel?.taskList[indexPath.section] ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0))
    }
}
