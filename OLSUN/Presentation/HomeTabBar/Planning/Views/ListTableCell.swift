//
//  ListTableCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import UIKit

enum TaskStatus: String {
    case completed = "Bitib"
    case inProgress = "İş davam edir"
    case delayed = "Gecikir"
    case accepted = "Qəbul edib"
    case pending = "Gözləmədə"
    case declined = "Uyğun deyil"

    var displayName: String {
        return self.rawValue
    }
}

struct TaskItem {
    var status: TaskStatus
    var title: String
    var descTitle: String
    var description: String
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
    
    func configure(with item: TaskItem) {
        switch item.status {
        case .completed:
            iconImageView.image = UIImage(systemName: "checkmark.square")
        case .inProgress:
            iconImageView.image = UIImage(systemName: "square")
        case .delayed:
            iconImageView.image = UIImage(systemName: "exclamationmark.square")
        case .accepted:
            iconImageView.image = UIImage(systemName: "checkmark.square")
        case .pending:
            iconImageView.image = UIImage(systemName: "square")
        case .declined:
            iconImageView.image = UIImage(systemName: "multiply.square")
        }
        deadlineLabel.text = item.descTitle
        titleLabel.text = item.title
        dateLabel.text = item.description
    }
    
    func configure(with item: ListCellProtocol) {
        switch item.statusString {
//        case .completed:
//            iconImageView.image = UIImage(systemName: "checkmark.square")
//        case .inProgress:
//            iconImageView.image = UIImage(systemName: "square")
//        case .delayed:
//            iconImageView.image = UIImage(systemName: "exclamationmark.square")
        case .accepted:
            iconImageView.image = UIImage(systemName: "checkmark.square")
            deadlineLabel.text = "Dəvət tarixi:"
        case .invited:
            iconImageView.image = UIImage(systemName: "square")
            deadlineLabel.text = "Dəvət tarixi:"
        case .declined:
            iconImageView.image = UIImage(systemName: "multiply.square")
            deadlineLabel.text = "Dəvət tarixi:"
        }
        
        titleLabel.text = item.titleString
        dateLabel.text = item.dateString.toDisplayDateFormat()
    }
}
