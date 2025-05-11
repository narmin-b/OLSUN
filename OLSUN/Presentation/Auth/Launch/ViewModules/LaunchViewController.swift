//
//  LaunchViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import UIKit
import SkeletonView

final class LaunchViewController: BaseViewController {
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
            labelText: OlsunStrings.launchMessage.localized,
            labelColor: .primaryHighlight,
            labelFont: .futuricaBold,
            labelSize: DeviceSizeClass.current == .compact ? 24 : 32,
            numOfLines: 3
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var launchImage: UIImageView = {
        let image = UIImageView()
        image.isSkeletonable = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
            labelFont: .workSansRegular,
            labelSize: DeviceSizeClass.current == .large ? 20 : 16,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "")
        textfield.textColor = .black
        textfield.tintColor = .clear
        textfield.addShadow()
        textfield.delegate = self
        textfield.inputAccessoryView = doneToolBar
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
            labelText: OlsunStrings.partnerNameText.localized,
            labelColor: .black,
            labelFont: .workSansRegular,
            labelSize: DeviceSizeClass.current == .large ? 20 : 16,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var partnerNameTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: ""
        )
        textfield.textColor = .black
        textfield.tintColor = .black
        textfield.addShadow()
        textfield.delegate = self
        textfield.inputAccessoryView = doneToolBar
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
            labelFont: .workSansRegular,
            labelSize: DeviceSizeClass.current == .large ? 20 : 16,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: OlsunStrings.optionalText.localized
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
        textfield.tintColor = .black
        textfield.addShadow()
        textfield.delegate = self
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var genderStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [genderLabel, genderTextfield])
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
            labelFont: .workSansRegular,
            labelSize: DeviceSizeClass.current == .large ? 20 : 16,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderTextfield: UITextField = {
        let textfield = ReusableTextField(
            placeholder:  OlsunStrings.optionalText.localized
        )
        
        let rightIcon = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill"))
        rightIcon.tintColor = .black
        rightIcon.isUserInteractionEnabled = true
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: rightIcon.frame.height))
        rightIcon.frame = CGRect(x: -8, y: 0, width: rightIcon.frame.width, height: rightIcon.frame.height)
        rightPaddingView.addSubview(rightIcon)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPicker))
        rightIcon.addGestureRecognizer(tapGestureRecognizer)
        
        textfield.rightView = rightPaddingView
        textfield.rightViewMode = .always
        
        textfield.textColor = .black
        textfield.tintColor = .clear
        textfield.addShadow()
        textfield.inputView = genderPicker
        textfield.delegate = self
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var genderPicker: UIPickerView = {
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.translatesAutoresizingMaskIntoConstraints = false
        return genderPicker
    }()
    
    private lazy var nextButton: UIButton = {
        let button = ReusableButton(
            title: OlsunStrings.nextButton.localized,
            onAction: { [weak self] in self?.nextTapped() },
            titleSize: DeviceSizeClass.current == .large ? 20 : 16,
            titleFont: .workSansMedium,
        )
        button.addShadow()
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
        view.spacing = 20
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
    
    let genders = [OlsunStrings.femaleText.localized, OlsunStrings.maleText.localized]
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
        
        launchImage.loadImage(named: "launchImage.png")
        
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
                    self.viewModel?.backToOnboarding()
                    self.showMessage(title: OlsunStrings.registerSuccessText.localized, message: OlsunStrings.registerSuccess_Message.localized)
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
        navigationController?.setNavigationBarHidden(false, animated: true)

        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
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
        
        let buttonHeight: CGFloat = DeviceSizeClass.current == .compact ? 48 : 52
        let nextButtonDist: CGFloat = DeviceSizeClass.current == .compact ? 24 : 40
        nextButton.anchor(
            bottom: view.bottomAnchor,
            padding: .init(all: nextButtonDist)
        )
        nextButton.centerXToSuperview()
        nextButton.anchorSize(.init(width: view.frame.width/3 + 12, height: buttonHeight))
        
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
            padding: .init(top: 0, left: 0, bottom: -24, right: 0)
        )
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    
        let height = DeviceSizeClass.current == .compact ? 120 : 164

        let titleContainer = UIView()
        titleContainer.addSubview(titleLabel)

        titleLabel.anchor(
            top: titleContainer.topAnchor,
            leading: titleContainer.leadingAnchor,
            bottom: titleContainer.bottomAnchor,
            trailing: titleContainer.trailingAnchor,
            padding: .init(top: 0, left: 24, bottom: 0, right: -24)
        )

        contentView.addArrangedSubview(titleContainer)
        contentView.addArrangedSubview(launchImage)
        launchImage.anchorSize(.init(width: 0, height: height))
        
        let textFieldHeight: CGFloat = DeviceSizeClass.current == .compact ? 32 : 36

        let nameContainer = UIView()
        nameContainer.addSubViews(nameLabel, nameTextField)
        nameLabel.anchor(
            top: nameContainer.topAnchor,
            leading: nameContainer.leadingAnchor,
            trailing: nameContainer.trailingAnchor,
            padding: .init(top: 0, left: 32, bottom: 0, right: -32)
        )
        nameTextField.anchor(
            top: nameLabel.bottomAnchor,
            leading: nameContainer.leadingAnchor,
            bottom: nameContainer.bottomAnchor,
            padding: .init(top: 8, left: 32, bottom: 0, right: 0)
        )
        nameTextField.anchorSize(.init(width: view.frame.width - 64, height: textFieldHeight))
        contentView.addArrangedSubview(nameContainer)

        let partnerNameContainer = UIView()
        partnerNameContainer.addSubViews(partnerNameLabel, partnerNameTextField)
        partnerNameLabel.anchor(
            top: partnerNameContainer.topAnchor,
            leading: partnerNameContainer.leadingAnchor,
            trailing: partnerNameContainer.trailingAnchor,
            padding: .init(top: 0, left: 32, bottom: 0, right: -32)
        )
        partnerNameTextField.anchor(
            top: partnerNameLabel.bottomAnchor,
            leading: partnerNameContainer.leadingAnchor,
            bottom: partnerNameContainer.bottomAnchor,
            padding: .init(top: 8, left: 32, bottom: 0, right: 0)
        )
        partnerNameTextField.anchorSize(.init(width: view.frame.width - 64, height: textFieldHeight))
        contentView.addArrangedSubview(partnerNameContainer)
     
        let dateContainer = UIView()
        dateContainer.addSubViews(dateLabel, dateTextField)
        dateLabel.anchor(
            top: dateContainer.topAnchor,
            leading: dateContainer.leadingAnchor,
            trailing: dateContainer.trailingAnchor,
            padding: .init(top: 0, left: 32, bottom: 0, right: -32)
        )
        dateTextField.anchor(
            top: dateLabel.bottomAnchor,
            leading: dateContainer.leadingAnchor,
            bottom: dateContainer.bottomAnchor,
            padding: .init(top: 8, left: 32, bottom: 0, right: 0)
        )
        dateTextField.anchorSize(.init(width: view.frame.width - 64, height: textFieldHeight))
        contentView.addArrangedSubview(dateContainer)
   
        let genderContainer = UIView()
        genderContainer.addSubViews(genderLabel, genderTextfield)
        genderLabel.anchor(
            top: genderContainer.topAnchor,
            leading: genderContainer.leadingAnchor,
            trailing: genderContainer.trailingAnchor,
            padding: .init(top: 0, left: 32, bottom: 0, right: -32)
        )
        genderTextfield.anchor(
            top: genderLabel.bottomAnchor,
            leading: genderContainer.leadingAnchor,
            bottom: genderContainer.bottomAnchor,
            padding: .init(top: 8, left: 32, bottom: 0, right: 0)
        )
        genderTextfield.anchorSize(.init(width: view.frame.width - 64, height: textFieldHeight))
        contentView.addArrangedSubview(genderContainer)
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
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder()
    }
    
    @objc private func cancelPressed() {
        dateTextField.resignFirstResponder()
    }
    
    @objc func openPicker() {
        if genderTextfield.text?.isEmpty ?? true {
            let defaultGender = genders[genderPicker.selectedRow(inComponent: 0)]
            genderTextfield.text = defaultGender
        }
        genderTextfield.becomeFirstResponder()
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
    
    fileprivate func checkInputRequirements() {
        let username = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let partnerName = partnerNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dateString = dateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let genderString = genderTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        
        var gender: Gender = .female
        var partnerGender: Gender = .male
        if genderString == "qadın" {
            gender = .female
            partnerGender = .male
        } else if genderString == "kişi" {
            gender = .male
            partnerGender = .female
        }
        
        checkErrorBorders(name: username, partnerName: partnerName, bday: dateString)
        
        if username.isValidName() && partnerName.isValidName() {
            let userInput = RegisterDataModel(
                username: username,
                gender: gender,
                coupleName: partnerName,
                coupleGender: partnerGender,
                bday: dateString
            )
            print(userInput)
            viewModel?.createUser(user: userInput)
        }
    }
    
    fileprivate func checkErrorBorders(name: String, partnerName: String, bday: String) {
        if !name.isValidName() {
            nameTextField.errorBorderOn()
        } else {
            nameTextField.borderOff()
        }
        if !partnerName.isValidName() {
            partnerNameTextField.errorBorderOn()
        } else {
            partnerNameTextField.borderOff()
        }
//        if !bday.isValidAge() {
//            dateTextField.errorBorderOn()
//        } else {
//            dateTextField.borderOff()
//        }
//        if genderTextfield.text?.isEmpty == true {
//            genderTextfield.errorBorderOn()
//        } else {
//            genderTextfield.borderOff()
//        }
    }
    
    fileprivate func textfieldCleaning() {
        nameTextField.text = ""
        partnerNameTextField.text = ""
        genderTextfield.text = ""
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

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

extension LaunchViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if genderTextfield.text?.isEmpty ?? true {
            let defaultGender = genders[genderPicker.selectedRow(inComponent: 0)]
            genderTextfield.text = defaultGender
        }
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextfield.text = genders[row]
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
