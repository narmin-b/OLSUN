//
//  ProfileInfoCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.05.25.
//

import UIKit

class ProfileInfoCell: UITableViewCell {
    
    static let identifier = "ProfileInfoCell"

    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .primaryHighlight,
            labelFont: .montserratSemiBold,
            labelSize: 16,
            numOfLines: 1
        )
        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize: 16,
            numOfLines: 1
        )
        label.textAlignment = .right
        return label
    }()

    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubviews(stackView, bottomBorder)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
    }
    
    fileprivate func setupConstraint() {
        stackView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 12, left: 24, bottom: -12, right: -24)
        )
        
        bottomBorder.anchor(
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 0, left: -16, bottom: 0, right: 16)
        )
        bottomBorder.anchorSize(.init(width: 0, height: 1))
    }

    func configure(title: String, value: String, showSeparator: Bool) {
        titleLabel.text = title
        valueLabel.text = value
        bottomBorder.isHidden = !showSeparator
    }
}
