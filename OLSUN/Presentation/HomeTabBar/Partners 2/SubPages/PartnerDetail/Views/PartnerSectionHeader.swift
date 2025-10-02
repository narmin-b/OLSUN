//
//  PartnerSectionHeader.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import Foundation
import UIKit

final class PartnerSectionHeader: UICollectionReusableView {
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.circle") 
        imageView.tintColor = .neutral500
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .neutral500,
            labelFont: .robotoSerifRegular,
            labelSize: DeviceSizeClass.current == .iPad ? 25 : 15
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubViews(iconView, titleLabel, bottomBorder)
        
        iconView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        iconView.anchorSize(.init(width: 20, height: 20))
        iconView.centerYToView(to: titleLabel)
        
        titleLabel.anchor(
            top: topAnchor,
            leading: iconView.trailingAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 8, bottom: 0, right: 0)
        )
        
        bottomBorder.anchor(
            top: titleLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        bottomBorder.anchorSize(.init(width: 0, height: 1))
    }
    
    func configure(with title: String, icon: String) {
        titleLabel.text = title
        iconView.image = UIImage(systemName: icon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
