//
//  MenuTableCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import UIKit

struct MenuItem {
    var iconName: String
    var title: String
    var description: String
}

final class MenuTableCell: UITableViewCell {
    let iconView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let gradient = CAGradientLayer()
  
    let titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Test",
            labelColor: .neutral800,
            labelFont: .robotoSerifMedium,
            labelSize: 24,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconView)
        
        gradient.colors = [UIColor.lg1.cgColor, UIColor.lg2.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1, y: 0.5)
        bgView.layer.insertSublayer(gradient, at: 0)

        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        selectionStyle = .none
        
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bgView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        
        iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 135).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 135).isActive = true
    }
    
    func configure(with item: MenuItem) {
        titleLabel.text = item.title
        iconView.image = UIImage(named: item.iconName)
        accessibilityIdentifier = "menuCell_\(item.title)"
    }
}
