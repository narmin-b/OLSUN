//
//  PlanningViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import UIKit

final class PlanningViewController: BaseViewController {
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
        let label = ReusableLabel(labelText: "Görəcəyin işlər",
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
            onAction: { [weak self] in self?.addTaskButtonTapped() },
            bgColor: .clear,
        )
//        button.setImage(UIImage(systemName: "plus"), for: .normal)
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
        tableview.isScrollEnabled = false
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    private let viewModel: PlanningViewModel?
    
    var taskItems: [TaskItem] = [
        TaskItem(status: .inProgress, title: "Fotoqraf", descTitle: "Deadline: ", description: "10.10.2025"),
        TaskItem(status: .completed, title: "Məkan", descTitle: "Deadline: ", description: "10.10.2025")
    ]
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
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
        view.addSubViews(loadingView, titleLabel, addTaskButton, tasksTableView)
        view.bringSubviewToFront(loadingView)
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
        
        tasksTableView.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(all: 16)
        )
        tasksTableView.anchorSize(.init(width: view.frame.width - 32, height: 300))
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
    
    @objc fileprivate func addTaskButtonTapped() {
        print(#function)
        viewModel?.showAddTaskVC()
    }
}

extension PlanningViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTableCell", for: indexPath) as? TasksTableCell else {
            return UITableViewCell()
        }
        cell.configure(with: taskItems[indexPath.section])
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
        viewModel?.taskSelected(taskItem: taskItems[indexPath.section])
    }
}
