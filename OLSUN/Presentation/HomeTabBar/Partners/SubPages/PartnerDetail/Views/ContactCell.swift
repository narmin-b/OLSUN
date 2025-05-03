//
//  ContactCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import UIKit

class ContactCell: UICollectionViewCell {
    static let identifier = "ContactCell"

    let iconView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        iconView.contentMode = .scaleAspectFit
        iconView.layer.cornerRadius = 8
        iconView.clipsToBounds = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with icon: Contact) {
        switch icon.name {
        case .instagram:
            iconView.image = UIImage(named: "igIcon")
        case .whatsapp:
            iconView.image = UIImage(named: "wpIcon")
        case .tiktok:
            iconView.image = UIImage(named: "tiktokIcon")
        }
    }
}
