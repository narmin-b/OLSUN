//
//  TaskViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import UIKit

final class TaskViewController: BaseViewController {
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
    
    private lazy var cancelTaskButton: UIButton = {
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
    
    private lazy var doneToolBar: UIToolbar = {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        keyboardToolbar.translatesAutoresizingMaskIntoConstraints = true
        return keyboardToolbar
    }()
    
    private let viewModel: TaskViewModel?
    let statusOptions = ["Bitib", "İş davam edir", "Gecikir"]
    private let toolbar = UIToolbar()
    private let datePicker = UIDatePicker()
    
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
        view.addSubViews(loadingView, titleLabel, editTaskButton, deadlineLabel, dateLabel, statusMenuButton, cancelButton, saveButton)
        view.bringSubviewToFront(loadingView)
        
        let menuItems = statusOptions.map { option in
            UIAction(title: option) { [weak self] _ in
                self?.statusMenuButton.setTitle(option, for: .normal)
                print("✅ Selected: \(option)")
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
            trailing: editTaskButton.leadingAnchor,
            padding: .init(top: 12, left: 8, bottom: 0, right: -8)
        )
        titleLabel.anchorSize(.init(width: 0, height: 36))
        
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
            padding: .init(top: 0, left: 0, bottom: 0, right: -8)
        )
        dateLabel.centerYToView(to: deadlineLabel)
        
        statusMenuButton.anchor(
            top: deadlineLabel.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 20, left: 16, bottom: 0, right: 0)
        )
        statusMenuButton.anchorSize(.init(width: view.frame.width/3 + 16, height: 44))
        
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
                case .success:
                    print(#function)
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    fileprivate func setUpTask(){
        titleLabel.attributedText = NSAttributedString(string: viewModel?.taskItem?.title ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 24), NSAttributedString.Key.foregroundColor: UIColor.primaryHighlight])
        dateLabel.attributedText = NSAttributedString(string: viewModel?.taskItem?.description ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 16), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        if let status = viewModel?.taskItem?.status.displayName {
            statusMenuButton.setTitle(status, for: .normal)
        }
    }
    
    @objc fileprivate func editTaskButtonTapped() {
        print(#function)
        toggleEditButtons()
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
    
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: datePicker.date)
        dateLabel.resignFirstResponder()
    }
    
    fileprivate func toggleEditButtons() {
        saveButton.isHidden.toggle()
        cancelButton.isHidden.toggle()
        titleLabel.isEnabled.toggle()
        dateLabel.isEnabled.toggle()
        editTaskButton.isHidden.toggle()
    }
    
    @objc fileprivate func saveTapped() {
        print(#function)
        toggleEditButtons()
    }
    
    @objc fileprivate func cancelTapped() {
        print(#function)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func cancelPressed() {
        dateLabel.resignFirstResponder()
    }
}

extension TaskViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == titleLabel {
            titleLabel.attributedText = NSAttributedString(string: textField.text ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: FontKeys.montserratMedium.rawValue, size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.primaryHighlight])
        }
    }
}
