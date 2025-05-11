////
////  ConfirmationView.swift
////  OLSUN
////
////  Created by Narmin Baghirova on 11.05.25.
////
//
//import UIKit
//
//final class ConfirmationView: UIView {
//
//    var onConfirm: (() -> Void)?
//    var onCancel: (() -> Void)?
//
//    // MARK: - UI Elements
//
//    private let backgroundView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private let containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 16
//        view.layer.masksToBounds = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: FontKeys.montserratBold.rawValue, size: 20)
//        label.textColor = .black
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let messageLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)
//        label.textColor = .darkGray
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let cancelButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitleColor(.black, for: .normal)
//        button.titleLabel?.font = UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)
//        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
//        button.layer.cornerRadius = 8
//        button.backgroundColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    
//    private let confirmButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .warningRed
//        button.layer.cornerRadius = 8
//        button.titleLabel?.font = UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)
//        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    // MARK: - Init
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        setUpConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Public Configuration
//
//    func configure(
//        title: String,
//        message: String,
//        confirmButtonTitle: String = OlsunStrings.deleteButton.localized,
//        cancelButtonTitle: String = OlsunStrings.cancelButton.localized
//    ) {
//        titleLabel.text = title
//        messageLabel.text = message
//        confirmButton.setTitle(confirmButtonTitle, for: .normal)
//        cancelButton.setTitle(cancelButtonTitle, for: .normal)
//    }
//
//    // MARK: - Setup
//
//    private func setupView() {
//        addSubview(backgroundView)
//        addSubview(containerView)
//        containerView.addSubviews(titleLabel, messageLabel, cancelButton, confirmButton)
//
//        backgroundView.pinToEdges(of: self)
//    }
//
//    private func setUpConstraints() {
//        containerView.centerXToSuperview()
//        containerView.centerYToSuperview()
//        containerView.anchorSize(.init(width: 300, height: 0))
//
//        titleLabel.anchor(
//            top: containerView.topAnchor,
//            leading: containerView.leadingAnchor,
//            trailing: containerView.trailingAnchor,
//            padding: .init(top: 24, left: 16, bottom: 0, right: -16)
//        )
//
//        messageLabel.anchor(
//            top: titleLabel.bottomAnchor,
//            leading: containerView.leadingAnchor,
//            trailing: containerView.trailingAnchor,
//            padding: .init(top: 12, left: 16, bottom: 0, right: -16)
//        )
//
//        // Cancel button on top
//        cancelButton.anchor(
//            top: messageLabel.bottomAnchor,
//            leading: containerView.leadingAnchor,
//            trailing: containerView.trailingAnchor,
//            padding: .init(top: 20, left: 16, bottom: 0, right: -16)
//        )
//        cancelButton.anchorSize(.init(width: 0, height: 44))
//
//        // Confirm button below
//        confirmButton.anchor(
//            top: cancelButton.bottomAnchor,
//            leading: containerView.leadingAnchor,
//            trailing: containerView.trailingAnchor,
//            padding: .init(top: 8, left: 16, bottom: 0, right: -16)
//        )
//        confirmButton.anchorSize(.init(width: 0, height: 44))
//
//        confirmButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
//    }
//    // MARK: - Actions
//
//    @objc private func cancelTapped() {
//        onCancel?()
//        removeFromSuperview()
//    }
//
//    @objc private func confirmTapped() {
//        onConfirm?()
//        removeFromSuperview()
//    }
//}
import UIKit

final class ConfirmationView: UIView {

    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?

    // MARK: - UI Elements

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontKeys.montserratBold.rawValue, size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .warningRed
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Configuration

    func configure(
        title: String,
        message: String,
        confirmButtonTitle: String = OlsunStrings.deleteButton.localized,
        cancelButtonTitle: String = OlsunStrings.cancelButton.localized
    ) {
        titleLabel.text = title
        messageLabel.text = message
        confirmButton.setTitle(confirmButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
    }

    // MARK: - Setup

    private func setupView() {
        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubviews(titleLabel, messageLabel, buttonStackView)
        buttonStackView.addArrangedSubview(confirmButton)
        buttonStackView.addArrangedSubview(cancelButton)

        backgroundView.pinToEdges(of: self)
    }

    private func setUpConstraints() {
        containerView.centerXToSuperview()
        containerView.centerYToSuperview()
        containerView.anchorSize(.init(width: 300, height: 0))

        titleLabel.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 24, left: 16, bottom: 0, right: -16)
        )

        messageLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 12, left: 16, bottom: 0, right: -16)
        )

        buttonStackView.anchor(
            top: messageLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: containerView.bottomAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 20, left: 16, bottom: -16, right: -16)
        )

        cancelButton.anchorSize(.init(width: 0, height: 44))
        confirmButton.anchorSize(.init(width: 0, height: 44))
    }

    // MARK: - Actions

    @objc private func cancelTapped() {
        onCancel?()
        removeFromSuperview()
    }

    @objc private func confirmTapped() {
        onConfirm?()
        removeFromSuperview()
    }
}
