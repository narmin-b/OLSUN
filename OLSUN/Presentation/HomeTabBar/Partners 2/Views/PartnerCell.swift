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
        iv.layer.cornerRadius = 5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var darkOverlay: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
//        
//        let dimView = UIView()
//        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
//        dimView.translatesAutoresizingMaskIntoConstraints = false
//        blurView.contentView.addSubview(dimView)
        
//        NSLayoutConstraint.activate([
//            dimView.topAnchor.constraint(equalTo: blurView.contentView.topAnchor),
//            dimView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor),
//            dimView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor),
//            dimView.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor)
//        ])
//        
        return blurView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .white,
            labelFont: .robotoSerifMedium,
            labelSize: 13,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tagLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .neutral400,
            labelFont: .robotoSerifRegular,
            labelSize: 11,
            numOfLines: 1
        )
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        imageView.addSubview(darkOverlay)
        darkOverlay.contentView.addSubviews(nameLabel, tagLabel)
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            darkOverlay.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            darkOverlay.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            darkOverlay.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            darkOverlay.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            nameLabel.topAnchor.constraint(equalTo: darkOverlay.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: darkOverlay.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: darkOverlay.trailingAnchor, constant: -8),
            
            tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            tagLabel.leadingAnchor.constraint(equalTo: darkOverlay.leadingAnchor, constant: 8),
            tagLabel.trailingAnchor.constraint(equalTo: darkOverlay.trailingAnchor, constant: -8),
            tagLabel.bottomAnchor.constraint(lessThanOrEqualTo: darkOverlay.bottomAnchor, constant: -8)
        ])
    }
    
    func configureCell(with partner: newPartner) {
        imageView.loadImage(named: partner.coverImage)
        nameLabel.text = partner.name
        tagLabel.text = "  \(partner.categoryDisplayName)  "
    }
}
