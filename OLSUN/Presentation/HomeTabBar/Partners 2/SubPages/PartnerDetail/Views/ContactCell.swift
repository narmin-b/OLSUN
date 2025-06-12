//
//  ContactCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import UIKit


class ContactCell: UICollectionViewCell {
    static let identifier = "ContactCell"

    var onIconTap: ((SocialMediaAccount) -> Void)?

    private lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        iv.addGestureRecognizer(tapGesture)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var currentIcon: SocialMediaAccount?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let size: CGFloat = {
            switch DeviceSizeClass.current {
            case .iPad:
                return 88
            default:
                return 68
            }
        }()
        
        contentView.addSubview(iconView)

        iconView.centerXToView(to: contentView)
        iconView.centerYToView(to: contentView)
        iconView.anchorSize(.init(width: size, height: size))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with icon: SocialMediaAccount) {
        currentIcon = icon

        switch icon.platformName {
        case "INSTAGRAM":
            iconView.image = UIImage(named: "igIcon")
        case "WHATSAPP":
            iconView.image = UIImage(named: "wpIcon")
        case "TIK TOK":
            iconView.image = UIImage(named: "tiktokIcon")
        default:
            return
        }
    }
    
    @objc func iconTapped() {
        guard let icon = currentIcon else { return }
        
        onIconTap?(icon)
        
        switch icon.platformName.uppercased() {
        case "INSTAGRAM", "TIK TOK":
            if let url = URL(string: icon.link) {
                let webVC = WebViewController(url: url)
                if let parentVC = self.parentViewController {
                    parentVC.present(webVC, animated: true, completion: nil)
                }
            }
            
        case "WHATSAPP":
            let message = "Salam! Mən OLSUN tətbiqindən gəlirəm.\nhttps://apps.apple.com/az/app/olsun/id6745569555"
            var phoneNumber = icon.link.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if phoneNumber.hasPrefix("+") {
                phoneNumber.removeFirst()
            } else if phoneNumber.hasPrefix("0") {
                phoneNumber.removeFirst()
            }
            
            phoneNumber = "994" + phoneNumber
            print("NUMMM: \(phoneNumber)")
            if let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=\(encodedMessage)"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                parentViewController?.showMessage(title: OlsunStrings.wpNotAvaiTitle.localized, message: OlsunStrings.wpNotAvaiMessage.localized)
            }
        default:
            break
        }
    }
}
