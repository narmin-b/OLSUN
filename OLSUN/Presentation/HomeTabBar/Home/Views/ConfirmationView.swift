//
//  ConfirmationView.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 11.05.25.
//

import UIKit

final class ConfirmationView: UIView {

    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?

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
        label.text =  OlsunStrings.accDeleteTitle.localized
        label.font = UIFont(name: FontKeys.montserratBold.rawValue, size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text =  OlsunStrings.accDelete_Message.localized
        label.font = UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle( OlsunStrings.cancelButton.localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle( OlsunStrings.deleteButton.localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubviews(titleLabel, messageLabel, cancelButton, deleteButton)

        backgroundView.pinToEdges(of: self)
    }
    
    fileprivate func setUpConstraints() {
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
        
        deleteButton.anchor(
            top: messageLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 20, left: 16, bottom: 0, right: -16)
        )
        deleteButton.anchorSize(.init(width: 0, height: 44))
        
        cancelButton.anchor(
            top: deleteButton.bottomAnchor,
            bottom: containerView.bottomAnchor,
            padding: .init(top: 8, left: 0, bottom: -16, right: 0)
        )
        cancelButton.centerXToView(to: containerView)
    }

    @objc private func cancelTapped() {
        onCancel?()
        removeFromSuperview()
    }

    @objc private func confirmTapped() {
        onConfirm?()
        removeFromSuperview()
    }
}
