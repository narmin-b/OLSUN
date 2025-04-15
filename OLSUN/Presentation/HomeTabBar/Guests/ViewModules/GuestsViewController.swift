//
//  GuestsViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import UIKit

final class GuestsViewController: BaseViewController {
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
        let label = ReusableLabel(labelText: "Qonaqların siyahısı",
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
            onAction: { [weak self] in self?.addGuestButtonTapped() },
            bgColor: .clear,
        )
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
        tableview.register(TasksTableCell.self, forCellReuseIdentifier: "TasksTableCell")
        tableview.separatorStyle = .none
        tableview.backgroundColor = .clear
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    private let viewModel: GuestsViewModel?
    
    var taskItems: [TaskItem] = [
        TaskItem(status: .pending, title: "Leyla", descTitle: "Dəvət tarixi: ", description: "09.10.2025"),
        TaskItem(status: .accepted, title: "Arzu", descTitle: "Dəvət tarixi: ", description: "09.10.2025")
    ]
    
    init(viewModel: GuestsViewModel) {
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
        viewModel?.getAllGuests()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        viewModel?.getAllGuests()
        print("id:", UserDefaultsHelper.getString(key: .userID))
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
        navigationItem.configureNavigationBar(text: "Qonaqlar")
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
                    self.tasksTableView.reloadData()
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    @objc fileprivate func addGuestButtonTapped() {
        viewModel?.showAddGuestVC()
    }
}

extension GuestsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.guestList.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTableCell", for: indexPath) as? TasksTableCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel?.guestList[indexPath.section] ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0))
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
        viewModel?.taskSelected(taskItem: viewModel?.guestList[indexPath.section] ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0))
    }
}
