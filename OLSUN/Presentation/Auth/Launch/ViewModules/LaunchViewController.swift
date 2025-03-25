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
            labelText: "First answer some questions about yourself!",
            labelColor: .primaryHighlight,
            labelFont: .workSansBold,
            labelSize: 32,
            numOfLines: 3
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Your name"
        )
        textfield.textColor = .black
        textfield.tintColor = .black
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var partnerNameTextField: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Your partner's name"
        )
        textfield.textColor = .black
        textfield.tintColor = .black
        textfield.inputAccessoryView = doneToolBar
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var genderTextfield: UITextField = {
        let textfield = ReusableTextField(
            placeholder: "Your gender"
        )
        
        let rightIcon = UIImageView(image: UIImage(systemName: "chevron.down"))
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
            title: "Next",
            onAction: nextTapped,
            titleFont: .interBold
        )
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
    
    private var isKeepLoggedIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    fileprivate func setUpBackground() {
        let backgroundView = GeometricBackgroundView(frame: view.bounds)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)

        backgroundView.fillSuperview()
    }
    
    fileprivate func configureNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.tintColor = .primaryHighlight
    }
    
    override func configureView() {
        setUpBackground()
        configureNavigationBar()
        
        view.backgroundColor = .backgroundMain
        view.addSubViews(loadingView, titleLabel, nameTextField, partnerNameTextField, genderTextfield, nextButton)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        
        if view.frame.height < 700 {
            titleLabel.anchor(
                top: view.safeAreaLayoutGuide.topAnchor,
                leading: view.leadingAnchor,
                trailing: view.trailingAnchor,
                padding: .init(top: 32, left: 52, bottom: 0, right: -52)
            )
        } else {
            titleLabel.anchor(
                top: view.safeAreaLayoutGuide.topAnchor,
                leading: view.leadingAnchor,
                trailing: view.trailingAnchor,
                padding: .init(top: 60, left: 52, bottom: 0, right: -52)
            )
        }
        
        titleLabel.centerXToSuperview()
        
        nameTextField.anchor(
            top: titleLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 60, left: 32, bottom: 0, right: -32)
        )
        nameTextField.centerXToSuperview()
        nameTextField.anchorSize(.init(width: 0, height: 44))
        
        partnerNameTextField.anchor(
            top: nameTextField.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 32, bottom: 0, right: -32)
        )
        partnerNameTextField.centerXToSuperview()
        partnerNameTextField.anchorSize(.init(width: 0, height: 44))
        
        genderTextfield.anchor(
            top: partnerNameTextField.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 32, bottom: 0, right: -32)
        )
        genderTextfield.centerXToSuperview()
        genderTextfield.anchorSize(.init(width: 0, height: 44))
        
        nextButton.anchor(
            leading: view.centerXAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 24, bottom: -48, right: -24)
        )
        nextButton.anchorSize(.init(width: 0, height: 44))
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
    
    @objc func openPicker() {
        genderTextfield.becomeFirstResponder()
    }
    
    @objc fileprivate func nextTapped() {
        print(#function)
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
