//
//  AddGuestViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import UIKit

final class AddGuestViewController: BaseViewController {
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
            labelText: OlsunStrings.guestName_Text.localized,
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
            placeholder: "Adı daxil edin",
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
            placeholder: "Tarixi seçin",
            placeholderColor: .black
        )
        textfield.backgroundColor = .clear
        textfield.font = UIFont(name: FontKeys.robotoSerifMedium.rawValue, size: 13)
        textfield.textAlignment = .right
        textfield.textColor = .black
        textfield.tintColor = .clear
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDatePicker))
        textfield.addGestureRecognizer(tapGesture)
        return textfield
    }()
    
    private lazy var statusMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Status", for: .normal)
        button.titleLabel?.font = UIFont(name: FontKeys.robotoSerifMedium.rawValue, size: 13)
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
        let title = OlsunStrings.deleteGuest_Text.localized
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontKeys.robotoSerifSemiBold.rawValue, size: 17)!,
            .foregroundColor: UIColor.red700
        ]
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.red700.cgColor
        button.layer.borderWidth = 1
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        button.addTarget(self, action: #selector(deleteGuest), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var doneToolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flex, done]
        return toolbar
    }()
    
    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    private var saveButtonBottomConstraint: NSLayoutConstraint!
    private var dateIconView: UIImageView?
    private var statusIconView: UIImageView?
    
    // MARK: Configurations
    private let viewModel: AddGuestViewModel?
    let statusOptions = [OlsunStrings.guestsStat_Accepted.localized, OlsunStrings.guestsStat_Pending.localized, OlsunStrings.guestsStat_Declined.localized]
    var onGuestUpdate: ((ListCellProtocol) -> Void)?
    
    init(viewModel: AddGuestViewModel) {
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.tabBar.isHidden = false
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureEditMode()
        setupDatePicker()
        configureStatusMenu()
    }
    
    override func configureView() {
        configureNavigationBar()
        view.backgroundColor = .white
        view.addSubViews(loadingView, titleLabel, nameTextField, dateContainer, statusContainer, deleteButton, saveButton)
        view.bringSubviewToFront(loadingView)
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
        navigationItem.configureNavigationBar(text: OlsunStrings.guestText.localized)
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
                    self.showMessage(
                        title: OlsunStrings.updateSuccessText.localized,
                        message: OlsunStrings.guestUpdateSuccess_Message.localized
                    ) {
                        self.onGuestUpdate?(guest)
                        self.viewModel?.popControllerBack()
                    }
                case .deleteSuccess:
                    self.showMessage(title: OlsunStrings.updateSuccessText.localized, message: OlsunStrings.guestDelete_Message.localized)
                case .success:
                    self.showMessage(
                        title: OlsunStrings.registerSuccessText.localized,
                        message: OlsunStrings.guestAdded_Message.localized
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
        //        datePicker.minimumDate = Date()
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
        checkNewGuest()
    }
    
    @objc func deleteGuest() {
        viewModel?.deleteGuest(id: viewModel?.guestItem.idInt ?? 0)
    }
    
    @objc fileprivate func cancelTapped() {
        viewModel?.popControllerBack()
        textfieldCleaning()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        let keyboardHeight = keyboardFrame.height
        saveButtonBottomConstraint.constant = -keyboardHeight - 16 // 16pt padding above keyboard
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: curve << 16),
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }

    @objc private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        saveButtonBottomConstraint.constant = -32 // back to original bottom spacing
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: curve << 16),
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
    
    fileprivate func checkNewGuest() {
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
            status = EditStatus.invited
        } else if statusMenuButton.currentTitle == statusOptions[2] {
            status = EditStatus.declined
        } else {
            status = EditStatus.invited
        }
        
        checkErrorBorders(name: name)
        if name.isValidName() && ((dateTextField.text?.isEmpty) == false) {
            let guestInput = GuestDataModel(
                id: viewModel?.guestItem.idInt ?? 0,
                name: name,
                guestInvitationDate: requestDateString,
                guestStatus: status
            )
            Logger.debug("\(guestInput)")
            viewModel?.performEdit(guest: guestInput)
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
        nameTextField.text = viewModel?.guestItem.titleString
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"
        
        if let rawDateString = viewModel?.guestItem.dateString,
           let date = inputFormatter.date(from: rawDateString) {
            datePicker.date = date
            dateTextField.text = outputFormatter.string(from: date)
        } else {
            dateTextField.text = ""
        }
        
        switch (viewModel?.guestItem.statusString) {
        case .accepted:
            statusMenuButton.setTitle(statusOptions[0], for: .normal)
        case .declined:
            statusMenuButton.setTitle(statusOptions[2], for: .normal)
        default:
            statusMenuButton.setTitle(statusOptions[1], for: .normal)
        }
    }
    
    private func configureStatusMenu() {
        let menuItems = statusOptions.map { option in
            UIAction(title: option) { [weak self] _ in
                self?.statusMenuButton.setTitle(option, for: .normal)
                self?.statusContainer.backgroundColor = .violet50
                self?.statusIconView?.isHidden = true
            }
        }
        statusMenuButton.menu = UIMenu(children: menuItems)
    }
    
    private func configureEditMode() {
        guard viewModel?.guestMode == .edit else { return }
        var statusString: String?
        let guest = viewModel?.guestItem
        if guest?.statusString.rawValue == "ACCEPTED" {
            statusString = "Qəbul edib"
        } else if guest?.statusString.rawValue == "INVITED" {
            statusString = "Qəbul edib"
        } else if guest?.statusString.rawValue == "PENDING" {
            statusString = "Gözləmədə"
        } else if guest?.statusString.rawValue == "DECLINED" {
            statusString = "Qəbul etməyib"
        } else {
            statusString = ""
        }
        
        nameTextField.text = viewModel?.guestItem.titleString
        dateTextField.text = viewModel?.guestItem.dateString
        statusMenuButton.setTitle(statusString, for: .normal)
        deleteButton.isHidden.toggle()
        
        if !(dateTextField.text?.isEmpty ?? true) {
            dateContainer.backgroundColor = .violet50
            dateIconView?.isHidden = true
        }
        if !(statusMenuButton.currentTitle?.isEmpty ?? true) {
            statusContainer.backgroundColor = .violet50
            statusIconView?.isHidden = true
        }
    }
    
    private func makeInputContainer(icon: UIImage, content: UIView, storeIn storage: inout UIImageView?) -> UIView {
        let iconView = UIImageView(image: icon)
        iconView.tintColor = .black
        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        storage = iconView 

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
    
}
