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
        imageView.contentMode = .scaleAspectFit
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
            labelSize: DeviceSizeClass.current == .iPad ? 36 : 16,
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !readMoreFlag else { return }
        
        let readmoreFont = UIFont(name: FontKeys.montserratBold.rawValue, size: DeviceSizeClass.current == .iPad ? 20 : 12)!
        let readmoreFontColor = UIColor.black

        descriptionLabel.numberOfLines = 3
        descriptionLabel.setTextWithTrailing(
            trailingText: "... ",
            moreText: OlsunStrings.moreText.localized,
            moreTextFont: readmoreFont,
            moreTextColor: readmoreFontColor
        )
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
            padding: .init(top: 0)
        )
        logoContainerView.centerXToView(to: contentView)
        logoContainerView.anchorSize(.init(width: 0, height: DeviceSizeClass.current == .iPad ? 300 : 200))

        logoImageView.centerInSuperview()
        logoImageView.anchorSize(.init(width: 0, height: DeviceSizeClass.current == .iPad ? 300 : 200))

        if let image = logoImageView.image {
            let aspectRatio = image.size.width / image.size.height
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: aspectRatio).isActive = true
        } else {
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 16.0 / 9.0).isActive = true
        }
        
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
    
    func configureCell(with partner: newPartner) {
        if let data = partner.description?.data(using: .utf16) {
            do {
                let originalAttributedString = try NSMutableAttributedString(
                    data: data,
                    options: [
                        .documentType: NSAttributedString.DocumentType.html,
                        .characterEncoding: String.Encoding.utf16.rawValue
                    ],
                    documentAttributes: nil
                )
                
                let customFont = UIFont(name: FontKeys.montserratMedium.rawValue, size: 16)!

                originalAttributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: originalAttributedString.length)) { value, range, _ in
                    if let oldFont = value as? UIFont {
                        var traits = oldFont.fontDescriptor.symbolicTraits
                        var fontDescriptor = customFont.fontDescriptor

                        if traits.contains(.traitBold) {
                            fontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold) ?? fontDescriptor
                        }
                        let newFont = UIFont(descriptor: fontDescriptor, size: customFont.pointSize)
                        originalAttributedString.addAttribute(.font, value: newFont, range: range)
                    }
                }

                descriptionLabel.attributedFullText = originalAttributedString
                descriptionLabel.attributedText = originalAttributedString
                
            } catch {
                print("Failed to convert HTML: \(error)")
            }
        }
        
        logoImageView.loadImage(named: partner.coverImage) { [weak self] image in
            guard let self, let image = image else { return }

            let aspectRatio = image.size.width / image.size.height

            self.logoImageView.constraints.forEach { constraint in
                if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                    self.logoImageView.removeConstraint(constraint)
                }
            }

            NSLayoutConstraint.activate([
                self.logoImageView.heightAnchor.constraint(equalToConstant: DeviceSizeClass.current == .iPad ? 300 : 200),
                self.logoImageView.widthAnchor.constraint(equalTo: self.logoImageView.heightAnchor, multiplier: aspectRatio)
            ])
        }
        
        if !readMoreFlag {
            let readmoreFont = UIFont(name: FontKeys.montserratBold.rawValue, size: DeviceSizeClass.current == .iPad ? 20 : 12)!
            let readmoreFontColor = UIColor.black

            descriptionLabel.numberOfLines = 3
            self.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.descriptionLabel.setTextWithTrailing(
                    trailingText: "...",
                    moreText: OlsunStrings.moreText.localized,
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
            descriptionLabel.attributedText = descriptionLabel.attributedFullText
        } else {
            descriptionLabel.numberOfLines = 3
            let readmoreFont = UIFont(name: FontKeys.montserratBold.rawValue, size: DeviceSizeClass.current == .iPad ? 20 : 12)!
            let readmoreFontColor = UIColor.black
            DispatchQueue.main.async {
                self.descriptionLabel.setTextWithTrailing(
                    trailingText: "...",
                    moreText: OlsunStrings.moreText.localized,
                    moreTextFont: readmoreFont,
                    moreTextColor: readmoreFontColor
                )
            }
        }
    }
}
