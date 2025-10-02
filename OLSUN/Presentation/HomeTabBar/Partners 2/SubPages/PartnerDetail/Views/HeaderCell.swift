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
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        descriptionLabel.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 8, left: 0, bottom: 0, right: 0)
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
                
                let customFont = UIFont(name: FontKeys.robotoSerifRegular.rawValue, size: 16)!

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
    
        if !readMoreFlag {
            let readmoreFont = UIFont(name: FontKeys.robotoSerifBold.rawValue, size: DeviceSizeClass.current == .iPad ? 20 : 13)!
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
            let readmoreFont = UIFont(name: FontKeys.robotoSerifBold.rawValue, size: DeviceSizeClass.current == .iPad ? 20 : 13)!
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
