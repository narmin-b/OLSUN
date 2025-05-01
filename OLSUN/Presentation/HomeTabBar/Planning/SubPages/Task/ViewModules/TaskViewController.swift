//
//  TaskViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import UIKit

final class TaskViewController: BaseViewController {
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
    
    private lazy var titleLabel: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "",
            backgroundColor: .clear,
        )
        textfield.attributedText = NSAttributedString(string: "Test", attributes: [NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.primaryHighlight])
        textfield.isEnabled = false
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var editTaskButton: UIButton = {
        let button = ReusableButton(
            title: "",
            onAction: { [weak self] in self?.editTaskButtonTapped() },
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
        let label = ReusableLabel(
            labelText: "Deadline:",
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize: 16,
            numOfLines: 1
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    private lazy var dateLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize: 16,
            numOfLines: 1
        )
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Status", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: FontKeys.workSansMedium.rawValue, size: 16)
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
    
    // MARK: Configurations
    private let viewModel: TaskViewModel?
    let statusOptions = ["Bitib", "Gözləmədə", "Gecikir"]
    
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
        
        setUpTask(with: viewModel?.taskItem ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0))
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(
            loadingView,
            titleLabel,
            editTaskButton,
            deadlineLabel,
            dateLabel,
            statusMenuButton
        )
        view.bringSubviewToFront(loadingView)
        
        let menuItems = statusOptions.map { option in
            UIAction(title: option) { [weak self] _ in
                self?.statusMenuButton.setTitle(option, for: .normal)
                self?.checkEditedTask()
            }
        }
        
        statusMenuButton.menu = UIMenu(title: "", options: .displayInline, children: menuItems)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: editTaskButton.leadingAnchor,
            padding: .init(top: 12, left: 8, bottom: 0, right: -8)
        )
        
        editTaskButton.anchor(
            trailing: view.trailingAnchor,
            padding: .init(all: 16)
        )
        editTaskButton.anchorSize(.init(width: 32, height: 32))
        editTaskButton.centerYToView(to: titleLabel)
        
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
        statusMenuButton.anchorSize(.init(width: view.frame.width/3 + 12, height: 44))
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
        navigationItem.configureNavigationBar(text: "Planlama")
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
                    self.setUpTask(with: self.viewModel?.taskItem ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0))
                case .error(let error):
                    self.setUpTask(with: self.viewModel?.taskItem ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0))
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    fileprivate func setUpTask(with guest: ListCellProtocol){
        titleLabel.attributedText = NSAttributedString(
            string: viewModel?.taskItem.titleString ?? "",
            attributes: [
                NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 24)!,
                NSAttributedString.Key.foregroundColor: UIColor.primaryHighlight
            ]
        )
        
        dateLabel.attributedText = NSAttributedString(
            string: viewModel?.taskItem.dateString.toDisplayDateFormat() ?? "",
            attributes: [
                NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)!,
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        )

        switch (viewModel?.taskItem.statusString) {
        case .accepted:
            statusMenuButton.setTitle(statusOptions[0], for: .normal)
        case .declined:
            statusMenuButton.setTitle(statusOptions[2], for: .normal)
        default:
            statusMenuButton.setTitle(statusOptions[1], for: .normal)
        }
    }
    
    // MARK: Functions
    @objc fileprivate func editTaskButtonTapped() {
        viewModel?.showEditTask()
    }

    fileprivate func checkEditedTask() {
        let name = titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let date = dateLabel.text
        var status: EditStatus
        if statusMenuButton.currentTitle == statusOptions[0] {
            status = EditStatus.accepted
        } else if statusMenuButton.currentTitle == statusOptions[1] {
            status = EditStatus.pending
        } else if statusMenuButton.currentTitle == statusOptions[2] {
            status = EditStatus.declined
        } else {
            status = EditStatus.pending
        }
 
        if name.isValidName() {
            let taskInput = PlanDataModel(
                id: viewModel?.taskItem.idInt,
                planTitle: name,
                deadline: date?.toAPIDateFormat() ?? "",
                status: status
            )
            
            Logger.debug("\(taskInput)")
            viewModel?.editTask(task: taskInput)
        }
    }
}
