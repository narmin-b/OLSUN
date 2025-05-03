//
//  PartnerCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 02.05.25.
//

import UIKit

enum ContactType: String {
    case instagram = "Instagram"
    case whatsapp = "Whatsapp"
    case tiktok = "TikTok"
}

struct Contact {
    let name: ContactType
    let link: String
}

// MARK: - Partner Model
struct Partner {
    let name: String
    let description: String
    let coverImage: UIImage
    let category: ServiceType
    let gallery: [UIImage]
    let logo: UIImage
    let contact: [Contact]
    let location: ServiceLocation
}

// MARK: - PartnerCell
class PartnerCell: UICollectionViewCell {
    static let identifier = "PartnerCell"

    let imageView = UIImageView()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let tagLabel = UILabel()
    let darkOverlay = UIView()
    let whiteOverlay = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false

        darkOverlay.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        darkOverlay.layer.cornerRadius = 16
        darkOverlay.translatesAutoresizingMaskIntoConstraints = false

        tagLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        tagLabel.textColor = .black
        tagLabel.backgroundColor = .secondaryHighlight
        tagLabel.layer.cornerRadius = 8
        tagLabel.clipsToBounds = true
        tagLabel.textAlignment = .left
        tagLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        whiteOverlay.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        whiteOverlay.layer.cornerRadius = 0
        whiteOverlay.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(darkOverlay)
        darkOverlay.addSubview(imageView)
        imageView.addSubview(tagLabel)
        imageView.addSubview(whiteOverlay)
        imageView.addSubview(nameLabel)
//        whiteOverlay.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
    }

    private func layoutViews() {
        darkOverlay.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(all: 4)
        )
        darkOverlay.anchorSize(.init(width: darkOverlay.frame.width, height: contentView.frame.height * 0.65))
        
        imageView.anchor(
            top: darkOverlay.topAnchor,
            leading: darkOverlay.leadingAnchor,
            bottom: darkOverlay.bottomAnchor,
            trailing: darkOverlay.trailingAnchor,
            padding: .init(all: 2)
        )
        
        tagLabel.anchor(
            top: imageView.topAnchor,
            leading: imageView.leadingAnchor,
            padding: .init(all: 8)
        )
        tagLabel.anchorSize(.init(width: 0, height: 20))
        
        whiteOverlay.anchor(
            leading: imageView.leadingAnchor,
            bottom: imageView.bottomAnchor,
            trailing: imageView.trailingAnchor,
            padding: .init(all: 0)
        )
        NSLayoutConstraint.activate([
            whiteOverlay.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.3)
        ])
        
        nameLabel.anchor(
            leading: whiteOverlay.leadingAnchor,
            bottom: whiteOverlay.bottomAnchor,
            trailing: whiteOverlay.trailingAnchor,
            padding: .init(all: 8)
        )
        
        descriptionLabel.anchor(
            top: darkOverlay.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 8, left: 8, bottom: 0, right: -4)
        )
    }

    func configure(with partner: Partner) {
        imageView.image = partner.coverImage
        nameLabel.text = partner.name
        descriptionLabel.text = partner.description
        tagLabel.text = "  \(partner.category.rawValue)  "
    }
}
