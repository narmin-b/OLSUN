//
//  LaunchViewController.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 20.03.25.
//

import UIKit

final class LaunchViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "İlk öncə daha yaxşı xidmət üçün bir neçə sualı cavablandır!",
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
        let image = UIImageView(image: UIImage(named: "launchImage"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Adınız",
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
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var partnerNameLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Partnyorunuzun adı",
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
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Yaşınız",
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
        textfield.tintColor = .black
        textfield.addShadow()
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Cinsiniz",
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
            placeholder: ""
        )
        
        let rightIcon = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill"))
        rightIcon.tintColor = .black
        rightIcon.isUserInteractionEnabled = true
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: rightIcon.frame.height))
        rightIcon.frame = CGRect(x: -8, y: 0, width: rightIcon.frame.width, height: rightIcon.frame.height)
        rightPaddingView.addSubview(rightIcon)
        
        textfield.rightView = rightPaddingView
        textfield.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPicker))
        rightIcon.addGestureRecognizer(tapGestureRecognizer)
        
        textfield.textColor = .black
        textfield.tintColor = .clear
        textfield.addShadow()
        textfield.inputView = genderPicker
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
            title: "Növbəti",
            onAction: nextTapped,
            titleSize: DeviceSizeClass.current == .large ? 20 : 16,
            titleFont: .workSansMedium,
        )
        button.addShadow()
        button.isHidden = false
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
    
    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    private let flag = UIScreen.main.bounds.height > 700 ? true : false
    private let deviceClass = DeviceSizeClass.current
    
    let genders = ["Female", "Male"]
    private let viewModel: LaunchViewModel?
    
    init(viewModel: LaunchViewModel) {
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
        setUpBackground()
        configureNavigationBar()
        setupDatePicker()
        
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, titleLabel, launchImage, nameLabel, nameTextField, partnerNameLabel, partnerNameTextField, dateLabel, dateTextField, genderLabel, genderTextfield, nextButton)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        let topConst: CGFloat = DeviceSizeClass.current == .compact ? 0 : 32
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: topConst, left: 24, bottom: 0, right: -24)
        )
        titleLabel.centerXToSuperview()
        
        let height = DeviceSizeClass.current == .compact ? 120 : 164
        launchImage.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 0, bottom: 0, right: 0)
        )
        launchImage.anchorSize(.init(width: 0, height: height))
        
        let textFieldHeight: CGFloat = DeviceSizeClass.current == .compact ? 32 : 36
        let textFieldDist: CGFloat = DeviceSizeClass.current == .compact ? 12 : 16

        nameLabel.anchor(
            top: launchImage.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: 24, left: 32, bottom: 0, right: 0)
        )
        nameTextField.anchor(
            top: nameLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 32, bottom: 0, right: -32)
        )
        nameTextField.centerXToSuperview()
        nameTextField.anchorSize(.init(width: 0, height: textFieldHeight))
        
        partnerNameLabel.anchor(
            top: nameTextField.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: textFieldDist, left: 32, bottom: 0, right: 0)
        )
        partnerNameTextField.anchor(
            top: partnerNameLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 32, bottom: 0, right: -32)
        )
        partnerNameTextField.centerXToSuperview()
        partnerNameTextField.anchorSize(.init(width: 0, height: textFieldHeight))
        
        dateLabel.anchor(
            top: partnerNameTextField.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: textFieldDist, left: 32, bottom: 0, right: 0)
        )
        dateTextField.anchor(
            top: dateLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 32, bottom: 0, right: -32)
        )
        dateTextField.centerXToSuperview()
        dateTextField.anchorSize(.init(width: 0, height: textFieldHeight))
        
        genderLabel.anchor(
            top: dateTextField.bottomAnchor,
            leading: view.leadingAnchor,
            padding: .init(top: textFieldDist, left: 32, bottom: 0, right: 0)
        )
        genderTextfield.anchor(
            top: genderLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 4, left: 32, bottom: 0, right: -32)
        )
        genderTextfield.centerXToSuperview()
        genderTextfield.anchorSize(.init(width: 0, height: textFieldHeight))
        
        let buttonHeight: CGFloat = DeviceSizeClass.current == .compact ? 48 : 52
        let nextButtonDist: CGFloat = DeviceSizeClass.current == .compact ? 24 : 40
        nextButton.anchor(
            bottom: view.bottomAnchor,
            padding: .init(all: nextButtonDist)
        )
        nextButton.centerXToSuperview()
        nextButton.anchorSize(.init(width: view.frame.width/3 + 12, height: buttonHeight))
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
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func openDatePicker() {
        dateTextField.becomeFirstResponder()
    }
    
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder()
    }
    
    @objc private func cancelPressed() {
        dateTextField.resignFirstResponder()
    }
    
    @objc func openPicker() {
        genderTextfield.becomeFirstResponder()
    }
    
    @objc fileprivate func nextTapped() {
        viewModel?.showSignupScreen()
    }
   
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LaunchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextfield.text = genders[row]
    }
}
