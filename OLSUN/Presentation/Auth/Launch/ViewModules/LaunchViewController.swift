//
//  LaunchViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import UIKit
import SkeletonView

final class LaunchViewController: BaseViewController, SelectionViewDelegate {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.nameText.localized,
            labelColor: .black,
            labelFont: .robotoSerifMedium,
            labelSize: 13,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Adınızı daxil edin",
            placeholderSize: 15,
            placeholderFont: .robotoSerifMedium,
            placeholderColor: .neutral400,
            borderColor: .neutraln200,
            borderWidth: 1
        )
        textfield.textColor = .black
        textfield.font = UIFont(name: "RobotoSerif-Medium", size: 15)
        textfield.delegate = self
        textfield.tintColor = .clear
        textfield.inputAccessoryView = doneToolBar
        textfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var partnerNameStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [partnerNameLabel, partnerNameTextField])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var partnerNameLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Soyadınız",
            labelColor: .black,
            labelFont: .robotoSerifMedium,
            labelSize: 13,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var partnerNameTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Soyadınızı daxil edin",
            placeholderSize: 15,
            placeholderFont: .robotoSerifMedium,
            placeholderColor: .neutral400,
            borderColor: .neutraln200,
            borderWidth: 1
        )
        textfield.textColor = .black
        textfield.font = UIFont(name: "RobotoSerif-Medium", size: 15)
        textfield.delegate = self
        textfield.inputAccessoryView = doneToolBar
        textfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var dateStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [dateLabel, dateTextField])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.bdayText.localized,
            labelColor: .black,
            labelFont: .robotoSerifMedium,
            labelSize: 13,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: OlsunStrings.optionalText.localized,
            placeholderSize: 15,
            placeholderFont: .robotoSerifMedium,
            placeholderColor: .neutral400,
            borderColor: .neutraln200,
            borderWidth: 1
        )
        textfield.textColor = .black
        textfield.font = UIFont(name: "RobotoSerif-Medium", size: 15)
        
        let rightIcon = UIImageView(image: UIImage(named: "calendar")?.withRenderingMode(.alwaysOriginal))
        rightIcon.tintColor = .black
        rightIcon.isUserInteractionEnabled = true
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: rightIcon.frame.height))
        rightIcon.frame = CGRect(x: -8, y: 0, width: rightIcon.frame.width, height: rightIcon.frame.height)
        rightPaddingView.addSubview(rightIcon)
        
        textfield.rightView = rightPaddingView
        textfield.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDatePicker))
        rightIcon.addGestureRecognizer(tapGestureRecognizer)
        
        textfield.delegate = self
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var genderStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [genderLabel, genderSelectionView])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = ReusableLabel(
            labelText: OlsunStrings.gendertext.localized,
            labelColor: .black,
            labelFont: .robotoSerifMedium,
            labelSize: 13,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderSelectionView = SelectionView(options: ["Kişi", "Qadın"])
  
    private lazy var nextButton: UIButton = {
        let button = ReusableButton(
            title: "Hesab yarat",
            onAction: { [weak self] in self?.nextTapped() },
            cornerRad: 16,
            bgColor: .violet300,
            titleSize: DeviceSizeClass.current == .large ? 20 : 16,
            titleFont: .robotoSerifSemiBold,
        )
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = DeviceSizeClass.current == .compact ? 12 : 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    private let deviceClass = DeviceSizeClass.current
    private var activeTextField: UITextField?
    var genderString: String? = ""
    
    private let viewModel: LaunchViewModel?
    
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        viewModel?.requestCallback = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textfieldCleaning()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        genderSelectionView.delegate = self
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureViewModel() {
        viewModel?.requestCallback = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.loadingView.startAnimating()
                case .loaded:
                    self.loadingView.stopAnimating()
                case .success:
                    self.showMessage(
                        title: OlsunStrings.registerSuccessText.localized,
                        message: OlsunStrings.registerSuccess_Message.localized
                    ) {
                        self.viewModel?.backToOnboarding()
                    }
                case .error(let error):
                    self.showMessage(title: "Error", message: error)
                }
            }
        }
    }
    
    fileprivate func setUpBackground() {
        let backgroundView = MeltingCircleBackgroundView(frame: view.bounds)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)

        backgroundView.fillSuperview()
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem(
            image: UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
        navigationItem.configureNavigationBar(text: "Qeydiyyat")
        navigationItem.leftBarButtonItem = backItem
    }
    
    func selectionView(_ selectionView: SelectionView, didSelect option: String) {
        genderString = option
    }
    
    override func configureView() {
        configureNavigationBar()
        setupDatePicker()
        
        view.backgroundColor = .white
        view.addSubViews(loadingView, nextButton, scrollView)
        scrollView.addSubview(contentView)
        
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        nextButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: -64, right: -16)
        )
        nextButton.anchorSize(.init(width: 0, height: 48))
        
        let topDist: CGFloat = DeviceSizeClass.current == .compact ? 48 : 102
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: nextButton.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: -4, right: 0)
        )
        contentView.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor,
            padding: .init(top: topDist, left: 0, bottom: -24, right: 0)
        )
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let nameContainer = UIView()
        nameContainer.addSubViews(nameLabel, nameTextField)
        nameLabel.anchor(
            top: nameContainer.topAnchor,
            leading: nameContainer.leadingAnchor,
            trailing: nameContainer.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: -16)
        )
        nameTextField.anchor(
            top: nameLabel.bottomAnchor,
            leading: nameContainer.leadingAnchor,
            bottom: nameContainer.bottomAnchor,
            padding: .init(top: 6, left: 16, bottom: 0, right: 0)
        )
        nameTextField.anchorSize(.init(width: view.frame.width - 3, height: 48))
        contentView.addArrangedSubview(nameContainer)

        let partnerNameContainer = UIView()
        partnerNameContainer.addSubViews(partnerNameLabel, partnerNameTextField)
        partnerNameLabel.anchor(
            top: partnerNameContainer.topAnchor,
            leading: partnerNameContainer.leadingAnchor,
            trailing: partnerNameContainer.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: -16)
        )
        partnerNameTextField.anchor(
            top: partnerNameLabel.bottomAnchor,
            leading: partnerNameContainer.leadingAnchor,
            bottom: partnerNameContainer.bottomAnchor,
            padding: .init(top: 6, left: 16, bottom: 0, right: 0)
        )
        partnerNameTextField.anchorSize(.init(width: view.frame.width - 32, height: 48))
        contentView.addArrangedSubview(partnerNameContainer)
     
        let genderContainer = UIView()
        genderContainer.addSubViews(genderLabel, genderSelectionView)
        genderLabel.anchor(
            top: genderContainer.topAnchor,
            leading: genderContainer.leadingAnchor,
            trailing: genderContainer.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: -16)
        )
        genderSelectionView.anchor(
            top: genderLabel.bottomAnchor,
            leading: genderContainer.leadingAnchor,
            bottom: genderContainer.bottomAnchor,
            padding: .init(top: 6, left: 16, bottom: 0, right: 0)
        )
        genderSelectionView.anchorSize(.init(width: view.frame.width - 32, height: 48))
        contentView.addArrangedSubview(genderContainer)
        
        let dateContainer = UIView()
        dateContainer.addSubViews(dateLabel, dateTextField)
        dateLabel.anchor(
            top: dateContainer.topAnchor,
            leading: dateContainer.leadingAnchor,
            trailing: dateContainer.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: -16)
        )
        dateTextField.anchor(
            top: dateLabel.bottomAnchor,
            leading: dateContainer.leadingAnchor,
            bottom: dateContainer.bottomAnchor,
            padding: .init(top: 6, left: 16, bottom: 0, right: 0)
        )
        dateTextField.anchorSize(.init(width: view.frame.width - 32, height: 48))
        contentView.addArrangedSubview(dateContainer)
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func openDatePicker() {
        dateTextField.becomeFirstResponder()
    }
    
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateLoginButton()
    }
    
    @objc private func cancelPressed() {
        dateTextField.resignFirstResponder()
    }
    
    @objc fileprivate func nextTapped() {
        checkInputRequirements()
    }
   
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func createUserWithPassword(user: RegisterDataModel) {
        viewModel?.createUser(user: user)
    }
    
    fileprivate func updateLoginButton() {
        let isEmailEmpty = nameTextField.text?.isEmpty ?? true
        let isPasswordEmpty = partnerNameTextField.text?.isEmpty ?? true

        if isEmailEmpty || isPasswordEmpty {
            nextButton.backgroundColor = .violet300
            nextButton.isUserInteractionEnabled = false
        } else {
            nextButton.backgroundColor = .violet700
            nextButton.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func checkInputRequirements() {
        let username = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let partnerName = partnerNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dateString = dateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        var gender: Gender?
        var partnerGender: Gender?
        if genderString == "Qadın" {
            gender = .female
            partnerGender = .male
        } else if genderString == "Kişi" {
            gender = .male
            partnerGender = .female
        }
        
        checkErrorBorders(name: username, partnerName: partnerName, bday: dateString)
        
        if username.isValidName() && partnerName.isValidName() {
            let backendDate = dateString.toBackendDate()
            let userInput = RegisterDataModel(
                username: username,
                gender: gender,
                coupleName: partnerName,
                coupleGender: partnerGender,
                bday: backendDate ?? ""
            )
            print(userInput)
            viewModel?.createUser(user: userInput)
        }
    }
    
    fileprivate func checkErrorBorders(name: String, partnerName: String, bday: String) {
        if !name.isValidName() {
            nameTextField.errorBorderOn()
        } else {
            nameTextField.layer.borderColor = UIColor.neutraln200.cgColor
            nameTextField.layer.borderWidth = 1
        }
        if !partnerName.isValidName() {
            partnerNameTextField.errorBorderOn()
        } else {
            partnerNameTextField.layer.borderColor = UIColor.neutraln200.cgColor
            partnerNameTextField.layer.borderWidth = 1
        }
    }
    
    fileprivate func textfieldCleaning() {
        nameTextField.text = ""
        partnerNameTextField.text = ""
        dateTextField.text = ""
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0) 
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset

        if let activeField = activeTextField {
            var visibleRect = scrollView.bounds
            visibleRect.size.height -= keyboardHeight

            let fieldFrameInScroll = activeField.convert(activeField.bounds, to: scrollView)

            if !visibleRect.contains(fieldFrameInScroll.origin) {
                scrollView.scrollRectToVisible(fieldFrameInScroll, animated: true)
            }
        }
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

extension LaunchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
