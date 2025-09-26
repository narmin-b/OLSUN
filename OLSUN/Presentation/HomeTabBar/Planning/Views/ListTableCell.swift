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
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .violet100
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.violet400.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Test",
            labelColor: .primaryHighlight,
            labelFont: .robotoSerifMedium,
            labelSize: 20,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let statusTextLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Status",
            labelColor: .gray,
            labelFont: .robotoSerifRegular,
            labelSize: 13,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Gözləmədə",
            labelColor: .systemOrange,
            labelFont: .robotoSerifMedium,
            labelSize: 15,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateTextLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Dəvətnamənin göndərilmə tarixi",
            labelColor: .gray,
            labelFont: .robotoSerifRegular,
            labelSize: 13,
            numOfLines: 2
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "11.11.1111",
            labelColor: .darkGray,
            labelFont: .robotoSerifMedium,
            labelSize: 15,
            numOfLines: 1
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dashedLineLayer = CAShapeLayer()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubViews(titleLabel, separator, statusTextLabel, statusLabel, dateTextLabel, dateLabel)
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addDottedSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        containerView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        titleLabel.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            padding: .init(top: 12, left: 12, bottom: 0, right: 0)
        )
        
        separator.anchor(
            top: titleLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 12, left: 12, bottom: 0, right: -12),
            size: .init(width: 0, height: 1)
        )
        
        statusTextLabel.anchor(
            top: separator.bottomAnchor,
            leading: containerView.leadingAnchor,
            padding: .init(top: 12, left: 12, bottom: 0, right: 0)
        )
        
        statusLabel.anchor(
            trailing: containerView.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: -12)
        )
        statusLabel.centerYToView(to: statusTextLabel)
        
        dateTextLabel.anchor(
            top: statusTextLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: containerView.bottomAnchor,
            padding: .init(top: 12, left: 12, bottom: -12, right: 0)
        )
        dateTextLabel.anchorSize(.init(width: 120, height: 0))
        
        dateLabel.anchor(
            trailing: containerView.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: -12)
        )
        dateLabel.centerYToView(to: dateTextLabel)
    }
    
    private func addDottedSeparator() {
        separator.layoutIfNeeded()
        dashedLineLayer.removeFromSuperlayer()
        
        dashedLineLayer.strokeColor = UIColor.gray.cgColor
        dashedLineLayer.lineWidth = 1
        dashedLineLayer.lineDashPattern = [4, 3]
        
        let width = separator.bounds.width
        let y = separator.bounds.midY
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: y),
                                CGPoint(x: width, y: y)])
        
        dashedLineLayer.path = path
        dashedLineLayer.frame = separator.bounds
        
        separator.layer.addSublayer(dashedLineLayer)
    }
    
    func configure(with item: ListCellProtocol, itemName: ItemName) {
        switch itemName {
        case .guest:
            dateTextLabel.text = OlsunStrings.guestsDate_Text.localized
            
            switch item.statusString {
            case .accepted:
                statusLabel.text = "Qəbul edib"
                statusLabel.textColor = .neutral800
            case .invited, .pending:
                statusLabel.text = "Gözləmədə"
                statusLabel.textColor = .yellow600
            case .declined:
                statusLabel.text = "Qəbul etməyib"
                statusLabel.textColor = .red600
            }
        case .task:
            dateTextLabel.text = OlsunStrings.planningDate_Text.localized
            
            switch item.statusString {
            case .accepted:
                statusLabel.text = "Bitmiş"
                statusLabel.textColor = .neutral800
            case .invited, .pending:
                statusLabel.text = "Gözləmədə"
                statusLabel.textColor = .yellow600
            case .declined:
                statusLabel.text = "Gecikir"
                statusLabel.textColor = .red600
            }
        }
        
        
        titleLabel.text = item.titleString
        dateLabel.text = item.dateString.toDisplayDateFormat()
    }
}

//final class ListTableCell: UITableViewCell {
//    let titleLabel: UILabel = {
//        let label = ReusableLabel(
//            labelText: "Test",
//            labelColor: .primaryHighlight,
//            labelFont: .workSansBold,
//            labelSize: 20,
//            numOfLines: 1
//        )
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let statusTextLabel: UILabel = {
//        let label = ReusableLabel(
//            labelText: "Status: ",
//            labelColor: .gray,
//            labelFont: .workSansRegular,
//            labelSize: 12,
//            numOfLines: 1
//        )
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let statusLabel: UILabel = {
//        let label = ReusableLabel(
//            labelText: "Pending",
//            labelColor: .darkGray,
//            labelFont: .workSansSemiBold,
//            labelSize: 12,
//            numOfLines: 1
//        )
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let deadlineLabel: UILabel = {
//        let label = ReusableLabel(
//            labelText: "Deadline: ",
//            labelColor: .gray,
//            labelFont: .workSansRegular,
//            labelSize: 12,
//            numOfLines: 1
//        )
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let dateLabel: UILabel = {
//        let label = ReusableLabel(
//            labelText: "11.11.1111",
//            labelColor: .darkGray,
//            labelFont: .workSansSemiBold,
//            labelSize: 12,
//            numOfLines: 1
//        )
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        contentView.addSubViews(titleLabel, deadlineLabel, dateLabel)
//        backgroundColor = .secondaryHighlight
//        layer.cornerRadius = 16
//        contentView.clipsToBounds = true
//        selectionStyle = .none
//        
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupConstraints() {
//        titleLabel.anchor(
//            top: topAnchor,
//            leading: leadingAnchor,
//            trailing: leadingAnchor,
//            padding: .init(top: 16, left: 24, bottom: 0, right: -12)
//        )
//        deadlineLabel.anchor(
//            top: titleLabel.bottomAnchor,
//            leading: leadingAnchor,
//            padding: .init(top: 2, left: 24, bottom: 0, right: 0)
//        )
//        dateLabel.anchor(
//            top: titleLabel.bottomAnchor,
//            leading: deadlineLabel.trailingAnchor,
//            padding: .init(top: 2, left: 2, bottom: 0, right: 0)
//        )
//    }
//    
//    func configure(with item: ListCellProtocol, itemName: ItemName) {
//        switch itemName {
//        case .guest:
//            deadlineLabel.text = OlsunStrings.guestsDate_Text.localized
//        case .task:
//            deadlineLabel.text = OlsunStrings.planningDate_Text.localized
//        }
//        
//        titleLabel.text = item.titleString
//        dateLabel.text = item.dateString.toDisplayDateFormat()
//    }
//}
