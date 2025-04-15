//
//  MenuTableCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import UIKit

struct MenuItem {
    var iconImage: UIImage
    var title: String
    var description: String
}

final class MenuTableCell: UITableViewCell {
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Test",
            labelColor: .primaryHighlight,
            labelFont: .workSansBold,
            labelSize: 20,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Test",
            labelColor: .gray,
            labelFont: .workSansRegular,
            labelSize: 12,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews(iconImageView, titleLabel, descriptionLabel)
        backgroundColor = .secondaryHighlight
        layer.cornerRadius = 16
        contentView.clipsToBounds = true
        selectionStyle = .none
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        iconImageView.anchor(
            top: self.topAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            padding: .init(top: 4, left: 0, bottom: -4, right: -12)
        )
        iconImageView.anchorSize(.init(width: DeviceSizeClass.current == .compact ? 60 : 68, height: DeviceSizeClass.current == .compact ? 60 : 68))
        
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            padding: .init(top: 16, left: 24, bottom: 0, right: 0)
        )
        descriptionLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: leadingAnchor,
            padding: .init(top: 2, left: 24, bottom: 0, right: 0)
        )
    }
    
    func configure(with item: MenuItem) {
        iconImageView.image = item.iconImage
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
}
