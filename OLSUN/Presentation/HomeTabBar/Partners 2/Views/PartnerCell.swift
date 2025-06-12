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
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let size: CGFloat = {
            switch DeviceSizeClass.current {
            case .iPad:
                return 32
            case .compact:
                return 12
            default:
                return 16
            }
        }()
        
        let label = ReusableLabel(
            labelText: "",
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize: size,
            numOfLines: 1,
        )
        label.accessibilityIdentifier = "partnersCellTitleLabel"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tagLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize: DeviceSizeClass.current == .iPad ? 20 : 12,
            numOfLines: 1,
            bgColor: .secondaryHighlight,
        )
        label.accessibilityIdentifier = "partnerDescCellTitleLabel"
        label.textAlignment = .left
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var darkOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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

        contentView.addSubview(darkOverlay)
        darkOverlay.addSubview(imageView)
        imageView.addSubview(tagLabel)
        contentView.addSubviews(nameLabel)
    }

    private func layoutViews() {
        darkOverlay.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(all: 4)
        )
        darkOverlay.anchorSize(.init(width: darkOverlay.frame.width, height: contentView.frame.height * 0.75))
        
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
        tagLabel.anchorSize(.init(width: 0, height: DeviceSizeClass.current == .iPad ? 28 : 20))
       
        nameLabel.anchor(
            top: darkOverlay.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(all: 8)
        )
    }
    
    func configureCell(with partner: newPartner) {
        imageView.loadImage(named: partner.coverImage)
        nameLabel.text = partner.name
        tagLabel.text = "  \(partner.categoryDisplayName)  "
    }
}
