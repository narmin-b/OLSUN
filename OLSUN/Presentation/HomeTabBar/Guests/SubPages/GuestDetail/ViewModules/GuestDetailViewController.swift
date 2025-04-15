////
////  GuestDetailViewController.swift
////  OLSUN
////
////  Created by Narmin Baghirova on 15.04.25.
////
//
//import UIKit

import UIKit

final class GuestDetailViewController: BaseViewController {
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
            cornerRadius: 12,
            backgroundColor: .clear,
        )
        textfield.delegate = self
        textfield.attributedText = NSAttributedString(string: "Test", attributes: [NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 24), NSAttributedString.Key.foregroundColor: UIColor.primaryHighlight])
        textfield.isEnabled = false
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var editGuestButton: UIButton = {
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
        let label = ReusableLabel(labelText: "Dəvət tarixi:",
                                  labelColor: .black,
                                  labelFont: .montserratMedium,
                                  labelSize: 16,
                                  numOfLines: 3
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "",
            cornerRadius: 8,
            backgroundColor: .clear,
        )
        textfield.delegate = self
        textfield.attributedText = NSAttributedString(string: "11.11.1111", attributes: [NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 16), NSAttributedString.Key.foregroundColor: UIColor.black])
        textfield.isEnabled = false
        
        textfield.inputView = datePicker
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        textfield.tintColor = .clear
        textfield.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDatePicker)))
        
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = ReusableButton(
            title: "İmtina et",
            onAction: { [weak self] in self?.cancelTapped() },
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
    
    private lazy var saveButton: UIButton = {
        let button = ReusableButton(
            title: "Yadda saxla",
            onAction: { [weak self] in self?.saveTapped() },
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
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let title = "Qonağı sil"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontKeys.workSansRegular.rawValue, size: 16)!,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.red
        ]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        button.addTarget(self, action: #selector(deleteGuest), for: .touchUpInside)
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
        keyboardToolbar.translatesAutoresizingMaskIntoConstraints = true
        return keyboardToolbar
    }()
    
    private let viewModel: GuestDetailViewModel?
    let statusOptions = ["Qəbul edib", "Gözləmədə", "Uyğun deyil"]
    private let toolbar = UIToolbar()
    private let datePicker = UIDatePicker()
    
    init(viewModel: GuestDetailViewModel) {
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
        
        setUpGuest(with: viewModel?.taskItem ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0))
        print(viewModel?.taskItem)
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
        view.addSubViews(loadingView, titleLabel, editGuestButton, deadlineLabel, dateLabel, statusMenuButton, deleteButton, cancelButton, saveButton)
        view.bringSubviewToFront(loadingView)
        
        let menuItems = statusOptions.map { option in
            UIAction(title: option) { [weak self] _ in
                self?.statusMenuButton.setTitle(option, for: .normal)
                self?.checkEditedGuest()
            }
        }
        
        statusMenuButton.menu = UIMenu(title: "", options: .displayInline, children: menuItems)
        setupDatePicker()
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: editGuestButton.leadingAnchor,
            padding: .init(top: 12, left: 8, bottom: 0, right: -8)
        )
        titleLabel.anchorSize(.init(width: 0, height: 36))
        
        editGuestButton.anchor(
            trailing: view.trailingAnchor,
            padding: .init(all: 16)
        )
        editGuestButton.anchorSize(.init(width: 32, height: 32))
        editGuestButton.centerYToView(to: titleLabel)
        
        deadlineLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 20, left: 16, bottom: 0, right: 0)
        )
        dateLabel.anchor(
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: -8)
        )
        dateLabel.centerYToView(to: deadlineLabel)
        
        statusMenuButton.anchor(
            top: deadlineLabel.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 20, left: 16, bottom: 0, right: 0)
        )
        statusMenuButton.anchorSize(.init(width: view.frame.width/3 + 8, height: 44))
        
        deleteButton.anchor(
            bottom: view.bottomAnchor,
            padding: .init(all: 92)
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
    
    private func configureViewModel() {
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.loadingView.startAnimating()
                case .loaded:
                    self.loadingView.stopAnimating()
                case .deleteSuccess:
                    self.viewModel?.popControllerBack()
                    self.showMessage(title: "Qonaq silindi!", message: "Məlumatlar uğurla yeniləndi.")
                case .editSuccess:
                    print(#function)
                case .success:
                    self.setUpGuest(with: self.viewModel?.taskItem ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0))
//                    self.showMessage(title: "Uğurlu dəyişikliklər!", message: "Məlumatlar uğurla yeniləndi.")
                case .error(let error):
                    self.setUpGuest(with: self.viewModel?.taskItem ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0))
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    fileprivate func setUpGuest(with guest: ListCellProtocol){
        titleLabel.attributedText = NSAttributedString(string: viewModel?.taskItem.titleString ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.primaryHighlight])
        dateLabel.attributedText = NSAttributedString(string: viewModel?.taskItem.dateString ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.black])

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: guest.dateString) {
            datePicker.date = date
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
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        
        dateLabel.inputView = datePicker
        dateLabel.inputAccessoryView = toolbar
    }
    
    @objc func openDatePicker() {
        dateLabel.becomeFirstResponder()
    }
    
    @objc fileprivate func editTaskButtonTapped() {
        viewModel?.showEditGuest()
//        toggleEditButtons()
//        titleLabel.backgroundColor = .secondaryHighlight
//        dateLabel.backgroundColor = .secondaryHighlight
    }
    
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = formatter.string(from: datePicker.date)
        dateLabel.resignFirstResponder()
    }
    
    fileprivate func toggleEditButtons() {
        saveButton.isHidden.toggle()
        cancelButton.isHidden.toggle()
        titleLabel.isEnabled.toggle()
        dateLabel.isEnabled.toggle()
        editGuestButton.isHidden.toggle()
        deleteButton.isHidden.toggle()
    }
    
    @objc fileprivate func saveTapped() {
        checkEditedGuest()
    }
    
    @objc fileprivate func cancelTapped() {
        toggleEditButtons()
        titleLabel.backgroundColor = .clear
        dateLabel.backgroundColor = .clear
        setUpGuest(with: viewModel?.taskItem ?? ListCellProtocol(titleString: "", dateString: "", statusString: .accepted, idInt: 0))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func deleteGuest() {
        viewModel?.deleteGuest(id: viewModel?.taskItem.idInt ?? 0)
    }
    
    @objc private func cancelPressed() {
        dateLabel.resignFirstResponder()
    }
    
    fileprivate func checkEditedGuest() {
        let name = titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let date = dateLabel.text
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
        if name.isValidName() {
            let guestInput = GuestDataModel(id: viewModel?.taskItem.idInt, name: name, guestInvitationDate: date ?? "", guestStatus: status)
            
            print(guestInput)
            viewModel?.editGuest(guest: guestInput)
        
        }
    }
    
    fileprivate func checkErrorBorders(name: String) {
        if !name.isValidName() {
            titleLabel.errorBorderOn()
        } else {
            titleLabel.borderOff()
        }
    }
}

extension GuestDetailViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == titleLabel {
            titleLabel.attributedText = NSAttributedString(string: textField.text ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.primaryHighlight])
        }
    }
}
