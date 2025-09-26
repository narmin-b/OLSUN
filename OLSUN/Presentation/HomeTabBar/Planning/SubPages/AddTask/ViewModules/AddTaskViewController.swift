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
            labelColor: .black,
            labelFont: .robotoSerifMedium,
            labelSize: 15,
            numOfLines: 1
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Planın adını daxil edin",
            placeholderFont: .robotoSerifMedium,
            placeholderColor: .gray,
            cornerRadius: 8,
            borderColor: .neutraln200,
            borderWidth: 1
        )
        textfield.font = UIFont(name: FontKeys.robotoSerifMedium.rawValue, size: 15)
        textfield.textColor = .black
        textfield.tintColor = .black
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
   
    private lazy var dateTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Tarix seçin",
            placeholderColor: .black
        )
        textfield.backgroundColor = .clear
        textfield.font = UIFont(name: FontKeys.robotoSerifMedium.rawValue, size: 13)
        textfield.textAlignment = .right
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDatePicker))
        textfield.addGestureRecognizer(tapGestureRecognizer)
        
        textfield.textColor = .black
        textfield.tintColor = .clear
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var statusMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Status ", for: .normal)
        button.titleLabel?.font = UIFont(name: FontKeys.robotoSerifMedium.rawValue, size: 13)
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12
        button.contentHorizontalAlignment = .left
        button.tintColor = .black
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dateContainer: UIView = {
        return makeInputContainer(icon: UIImage(systemName: "calendar")!,
                                  content: dateTextField,
                                  storeIn: &dateIconView)
    }()

    private lazy var statusContainer: UIView = {
        return makeInputContainer(icon: UIImage(systemName: "clock.badge")!,
                                  content: statusMenuButton,
                                  storeIn: &statusIconView)
    }()
    
    private lazy var saveButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.saveButton.localized,
            onAction: { [weak self] in self?.saveTapped() },
            titleSize: 17,
            titleFont: .robotoSerifSemiBold
        )
        button.backgroundColor = .violet700
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let title = OlsunStrings.deletePlan_Text.localized
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontKeys.robotoSerifSemiBold.rawValue, size: 17)!,
            .foregroundColor: UIColor.red700
        ]
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.red700.cgColor
        button.layer.borderWidth = 1
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
    private var saveButtonBottomConstraint: NSLayoutConstraint!
    private var dateIconView: UIImageView?
    private var statusIconView: UIImageView?
    
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
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureEditMode()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, titleLabel, nameTextField, dateContainer, statusContainer, deleteButton, saveButton)
        view.bringSubviewToFront(loadingView)
        
        setupDatePicker()
        
        let menuItems = statusOptions.map { option in
            UIAction(title: option) { [weak self] _ in
                guard let self = self else { return }
                self.statusMenuButton.setTitle(option, for: .normal)

                // 🔹 Update container + hide icon
                self.statusContainer.backgroundColor = .violet50
                self.statusIconView?.isHidden = true

                Logger.debug("✅ Selected: \(option)")
            }
        }
        statusMenuButton.menu = UIMenu(children: menuItems)
        statusMenuButton.showsMenuAsPrimaryAction = true
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
            padding: .init(top: 12, left: 16, bottom: 0, right: -16)
        )
        nameTextField.anchorSize(.init(width: 0, height: 64))
        
        dateContainer.anchor(
            top: nameTextField.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.centerXAnchor,
            padding: .init(top: 24, left: 16, bottom: 0, right: -8)
        )
        dateContainer.anchorSize(.init(width: 0, height: 54))

        statusContainer.anchor(
            top: nameTextField.bottomAnchor,
            leading: view.centerXAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 24, left: 8, bottom: 0, right: -16)
        )
        statusContainer.anchorSize(.init(width: 0, height: 54))
        
        deleteButton.anchor(
            leading: view.leadingAnchor,
            bottom: saveButton.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: -8 , right: -16)
        )
        deleteButton.anchorSize(.init(width: 0, height: 56))
        deleteButton.centerXToSuperview()
        
        saveButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: -32 , right: -16)
        )
        saveButton.anchorSize(.init(width: 0, height: 56))
        saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
        saveButtonBottomConstraint.isActive = true
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
    
    private func makeInputContainer(icon: UIImage, content: UIView, storeIn storage: inout UIImageView?) -> UIView {
        let iconView = UIImageView(image: icon)
        iconView.tintColor = .black
        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        storage = iconView // save reference

        let stack = UIStackView(arrangedSubviews: [content, iconView])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.backgroundColor = .newGray
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])

        return container
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {

            saveButtonBottomConstraint.constant = -keyboardFrame.height - 16
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            saveButtonBottomConstraint.constant = -32
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func openDatePicker() {
        dateTextField.becomeFirstResponder()
    }
    
    @objc private func donePressed() {
        let uiFormatter = DateFormatter()
        uiFormatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = uiFormatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder()

        // Update UI
        dateContainer.backgroundColor = .violet50
        dateIconView?.isHidden = true
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
    
    private func configureEditMode() {
        guard viewModel?.taskMode == .edit else { return }
        var statusString: String?
        let task = viewModel?.taskItem
        if task?.statusString.rawValue == "ACCEPTED" {
            statusString = "Bitmiş"
        } else if task?.statusString.rawValue == "INVITED" {
            statusString = "Qəbul edib"
        } else if task?.statusString.rawValue == "PENDING" {
            statusString = "Gözləmədə"
        } else if task?.statusString.rawValue == "DECLINED" {
            statusString = "Gecikir"
        } else {
            statusString = ""
        }
        
        nameTextField.text = task?.titleString
        
        dateTextField.text = task?.dateString
        statusMenuButton.setTitle(statusString, for: .normal)
        
        if !(task?.dateString.isEmpty ?? true) {
            dateContainer.backgroundColor = .violet50
            dateIconView?.isHidden = true
        }
        if !(statusString?.isEmpty ?? true) {
            statusContainer.backgroundColor = .violet50
            statusIconView?.isHidden = true
        }
        deleteButton.isHidden.toggle()
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
