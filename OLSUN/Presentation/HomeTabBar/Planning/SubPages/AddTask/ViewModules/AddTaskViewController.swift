//
//  AddTaskViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import UIKit

final class AddTaskViewController: BaseViewController {
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
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.planName_Text.localized,
            labelColor: .primaryHighlight,
            labelFont: .montserratMedium,
            labelSize: 24,
            numOfLines: 1
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "")
        textfield.textColor = .black
        textfield.tintColor = .black
        textfield.addShadow()
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.planningDate_Text.localized,
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize: 16,
            numOfLines: 1
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: ""
        )
        
        let rightIcon = UIImageView(image: UIImage(systemName: "calendar"))
        rightIcon.tintColor = .black
        rightIcon.isUserInteractionEnabled = true
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: rightIcon.frame.height))
        rightIcon.frame = CGRect(x: -8, y: 0, width: rightIcon.frame.width, height: rightIcon.frame.height)
        rightPaddingView.addSubview(rightIcon)
        
        textfield.rightView = rightPaddingView
        textfield.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDatePicker))
        rightIcon.addGestureRecognizer(tapGestureRecognizer)
        
        textfield.textColor = .black
        textfield.tintColor = .clear
        textfield.addShadow()
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.statusText.localized,
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize: 16,
            numOfLines: 3
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: -12, bottom: 12, right: 0)
        button.tintColor = .black
        button.showsMenuAsPrimaryAction = true
        button.addShadow()
        button.addRightImage(image: UIImage(systemName: "chevron.down")!, offset: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.cancelButton.localized,
            onAction: { [weak self] in self?.cancelTapped() },
            bgColor: .accentMain,
            titleColor: .primaryHighlight,
            titleSize: DeviceSizeClass.current == .compact ? 16 : 20,
            titleFont: .workSansMedium
        )
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.saveButton.localized,
            onAction: { [weak self] in self?.saveTapped() },
            titleSize: DeviceSizeClass.current == .compact ? 16 : 20,
            titleFont: .workSansMedium
        )
        button.addShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let title = OlsunStrings.deletePlan_Text.localized
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontKeys.workSansRegular.rawValue, size: 16)!,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.red
        ]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        button.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        button.isHidden = true
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
    
    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    
    // MARK: Configurations
    private let viewModel: AddTaskViewModel?
    let statusOptions = [OlsunStrings.planningStat_Done.localized, OlsunStrings.planningStat_Pending.localized, OlsunStrings.planningStat_Late.localized]
    var onTaskUpdate: ((ListCellProtocol) -> Void)?
    
    init(viewModel: AddTaskViewModel) {
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
        
        switch viewModel?.taskMode {
        case .add:
            deleteButton.isHidden = true
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let today = Date()
            dateTextField.text = formatter.string(from: today)
            datePicker.date = today
            statusMenuButton.setTitle(OlsunStrings.planningStat_Pending.localized, for: .normal)
        case .edit:
            deleteButton.isHidden = false
            setUpGuestInfo()
        case .none:
            return
        }
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, titleLabel, nameTextField, dateLabel, dateTextField, statusLabel, statusMenuButton, deleteButton, cancelButton, saveButton)
        view.bringSubviewToFront(loadingView)
        
        setupDatePicker()
        
        let menuItems = statusOptions.map { option in
            UIAction(title: option) { [weak self] _ in
                self?.statusMenuButton.setTitle(option, for: .normal)
                Logger.debug("✅ Selected: \(option)")
            }
        }
        
        statusMenuButton.menu = UIMenu(title: "", options: .displayInline, children: menuItems)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 12, left: 16, bottom: 0, right: 0)
        )
        
        nameTextField.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 32, bottom: 0, right: -32)
        )
        nameTextField.anchorSize(.init(width: 0, height: 36))
        
        dateLabel.anchor(
            top: nameTextField.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 36, left: 16, bottom: 0, right: 0)
        )
        
        dateTextField.anchor(
            top: nameTextField.bottomAnchor,
            leading: view.centerXAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 36, left: 0, bottom: 0, right: -16)
        )
        dateTextField.anchorSize(.init(width: 0, height: 36))
        
        statusLabel.anchor(
            top: dateTextField.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 20, left: 16, bottom: 0, right: 0)
        )
        
        statusMenuButton.anchor(
            top: dateTextField.bottomAnchor,
            leading: view.centerXAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 0, right: -16)
        )
        statusMenuButton.anchorSize(.init(width: 0, height: 36))
        
        deleteButton.anchor(
            bottom: view.bottomAnchor,
            padding: .init(all: 100)
        )
        deleteButton.centerXToSuperview()
        
        cancelButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.centerXAnchor,
            padding: .init(top: 0, left: 32, bottom: -32 , right: -8)
        )
        cancelButton.anchorSize(.init(width: 0, height: 48))
        
        saveButton.anchor(
            leading: view.centerXAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 8, bottom: -32 , right: -32)
        )
        saveButton.anchorSize(.init(width: 0, height: 48))
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
        navigationItem.configureNavigationBar(text: OlsunStrings.planningText.localized)
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
                case .editSuccess(let guest):
                    self.onTaskUpdate?(guest)
                    self.viewModel?.popControllerBack()
                    self.showMessage(title: OlsunStrings.updateSuccessText.localized, message: OlsunStrings.planUpdateSuccess_Message.localized)
                case .deleteSuccess:
                    self.showMessage(title: OlsunStrings.updateSuccessText.localized, message: OlsunStrings.planDelete_Message.localized)
                case .success:
                    self.showMessage(
                        title: OlsunStrings.registerSuccessText.localized,
                        message: OlsunStrings.planAdded_Message.localized
                    ) {
                        self.viewModel?.popControllerBack()
                    }
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    // MARK: Functions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(datePickerCancelPressed))
        
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func openDatePicker() {
        dateTextField.becomeFirstResponder()
    }
    
    @objc private func donePressed() {
        let uiFormatter = DateFormatter()
        uiFormatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = uiFormatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder()
    }
    
    @objc private func datePickerCancelPressed() {
        dateTextField.resignFirstResponder()
    }
    
    @objc fileprivate func saveTapped() {
        checkNewTask()
    }
    
    @objc func deleteTask() {
        viewModel?.deleteTask(id: viewModel?.taskItem.idInt ?? 0)
    }
    
    @objc fileprivate func cancelTapped() {
        viewModel?.popControllerBack()
        textfieldCleaning()
    }
    
    fileprivate func checkNewTask() {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        var requestDateString = ""
        if let textDate = dateTextField.text {
            let uiFormatter = DateFormatter()
            uiFormatter.dateFormat = "dd.MM.yyyy"
            
            let apiFormatter = DateFormatter()
            apiFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = uiFormatter.date(from: textDate) {
                requestDateString = apiFormatter.string(from: date)
            }
        }
        
        var status: EditStatus
        if statusMenuButton.currentTitle == statusOptions[0] {
            status = EditStatus.accepted
        } else if statusMenuButton.currentTitle == statusOptions[1] {
            status = EditStatus.pending
        } else if statusMenuButton.currentTitle == statusOptions[2] {
            status = EditStatus.declined
        } else {
            status = EditStatus.invited
        }
        
        checkErrorBorders(name: name)
        if name.isValidName() && ((dateTextField.text?.isEmpty) == false) {
            let taskInput = PlanDataModel(
                id: viewModel?.taskItem.idInt ?? 0,
                planTitle: name,
                deadline: requestDateString,
                status: status
            )
            Logger.debug("\(taskInput)")
            viewModel?.performEdit(task: taskInput)
        }
    }
    
    fileprivate func checkErrorBorders(name: String) {
        if !name.isValidName() {
            nameTextField.errorBorderOn()
        } else {
            nameTextField.borderOff()
        }
        if dateTextField.text?.isEmpty ?? true {
            dateTextField.errorBorderOn()
        } else {
            dateTextField.borderOff()
        }
    }
    
    fileprivate func textfieldCleaning() {
        nameTextField.text = ""
        dateTextField.text = ""
        statusMenuButton.setTitle("", for: .normal)
    }
    
    fileprivate func setUpGuestInfo() {
        nameTextField.text = viewModel?.taskItem.titleString
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"
        
        if let rawDateString = viewModel?.taskItem.dateString,
           let date = inputFormatter.date(from: rawDateString) {
            datePicker.date = date
            dateTextField.text = outputFormatter.string(from: date)
        } else {
            dateTextField.text = ""
        }
        
        switch (viewModel?.taskItem.statusString) {
        case .accepted:
            statusMenuButton.setTitle(statusOptions[0], for: .normal)
        case .declined:
            statusMenuButton.setTitle(statusOptions[2], for: .normal)
        default:
            statusMenuButton.setTitle(statusOptions[1], for: .normal)
        }
    }
}
