//
//  ListTableCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import UIKit

enum ItemName {
    case guest
    case task
}

final class ListTableCell: UITableViewCell {
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .primaryHighlight
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
    
    let deadlineLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Deadline: ",
            labelColor: .gray,
            labelFont: .workSansRegular,
            labelSize: 12,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "11.11.1111",
            labelColor: .darkGray,
            labelFont: .workSansSemiBold,
            labelSize: 12,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubViews(iconImageView, titleLabel, deadlineLabel, dateLabel)
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
            trailing: trailingAnchor,
            padding: .init(all: 24)
        )
        iconImageView.centerYToSuperview()
        iconImageView.anchorSize(.init(width: 24, height: 24))
        
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            padding: .init(top: 16, left: 24, bottom: 0, right: 0)
        )
        deadlineLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: leadingAnchor,
            padding: .init(top: 2, left: 24, bottom: 0, right: 0)
        )
        dateLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: deadlineLabel.trailingAnchor,
            padding: .init(top: 2, left: 2, bottom: 0, right: 0)
        )
    }
    
    func configure(with item: ListCellProtocol, itemName: ItemName) {
        switch itemName {
        case .guest:
            switch item.statusString {
            case .accepted:
                iconImageView.image = UIImage(systemName: "checkmark.square")
                deadlineLabel.text = OlsunStrings.guestsDate_Text.localized
            case .invited:
                iconImageView.image = UIImage(systemName: "square")
                deadlineLabel.text = OlsunStrings.guestsDate_Text.localized
            case .declined:
                iconImageView.image = UIImage(systemName: "multiply.square")
                deadlineLabel.text = OlsunStrings.guestsDate_Text.localized
            case .pending:
                iconImageView.image = UIImage(systemName: "square")
                deadlineLabel.text = OlsunStrings.guestsDate_Text.localized
            }
        case .task:
            switch item.statusString {
            case .accepted:
                iconImageView.image = UIImage(systemName: "checkmark.square")
                deadlineLabel.text = OlsunStrings.planningDate_Text.localized
            case .invited:
                iconImageView.image = UIImage(systemName: "square")
                deadlineLabel.text = OlsunStrings.planningDate_Text.localized
            case .declined:
                iconImageView.image = UIImage(systemName: "exclamationmark.square")
                deadlineLabel.text = OlsunStrings.planningDate_Text.localized
            case .pending:
                iconImageView.image = UIImage(systemName: "square")
                deadlineLabel.text = OlsunStrings.planningDate_Text.localized
            }
        }
        
        titleLabel.text = item.titleString
        dateLabel.text = item.dateString.toDisplayDateFormat()
    }
}
