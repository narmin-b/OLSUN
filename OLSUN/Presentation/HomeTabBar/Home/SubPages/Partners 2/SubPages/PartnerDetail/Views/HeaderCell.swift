//
//  HeaderCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import UIKit

protocol HeaderCellDelegate: AnyObject {
    func didTapReadMore(in cell: HeaderCell)
}

class HeaderCell: UICollectionViewCell {
    static let identifier = "HeaderCell"
    private var readMoreFlag = false

    private lazy var logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "",
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize: 16,
            numOfLines: 3
        )
        label.accessibilityIdentifier = "partnersDescriptionLabel"
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(readMoreClicked))
        label.addGestureRecognizer(tapGestureRecognizer)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: HeaderCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(logoContainerView)
        logoContainerView.addSubview(logoImageView)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        logoContainerView.anchor(
            top: contentView.topAnchor,
            padding: .init(all: 0)
        )
        logoContainerView.centerXToView(to: contentView)
        logoContainerView.anchorSize(.init(width: contentView.frame.width/2, height: (contentView.frame.width/2)*0.6))
        
        logoImageView.fillSuperview()
        
        descriptionLabel.anchor(
            top: logoContainerView.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 16, left: 0, bottom: 0, right: 0)
        )
    }
    
    @objc private func readMoreClicked() {
        delegate?.didTapReadMore(in: self)
    }
   
    func configureCell(with partner: Partner) {
        logoImageView.image = partner.logo
        descriptionLabel.text = partner.description
        descriptionLabel.fullText = partner.description

        if !readMoreFlag {
            let readmoreFont = UIFont(name: FontKeys.montserratBold.rawValue, size: 12)!
            let readmoreFontColor = UIColor.black

            DispatchQueue.main.async {
                self.descriptionLabel.setTextWithTrailing(
                    trailingText: "...",
                    moreText: "Daha çox",
                    moreTextFont: readmoreFont,
                    moreTextColor: readmoreFontColor
                )
            }
        }
    }
    
    func toggleDescription() {
        readMoreFlag.toggle()

        if readMoreFlag {
            descriptionLabel.numberOfLines = 0
            descriptionLabel.text = descriptionLabel.fullText
        } else {
            descriptionLabel.numberOfLines = 3
            let readmoreFont = UIFont(name: FontKeys.montserratBold.rawValue, size: 12)!
            let readmoreFontColor = UIColor.black
            DispatchQueue.main.async {
                self.descriptionLabel.setTextWithTrailing(
                    trailingText: "...",
                    moreText: "Daha çox",
                    moreTextFont: readmoreFont,
                    moreTextColor: readmoreFontColor
                )
            }
        }
    }
}
