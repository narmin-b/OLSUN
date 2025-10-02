//
//  FilterCell.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 29.09.25.
//

import UIKit

struct FilterOption {
    let title: String
    var isSelected: Bool
}

final class FilterCell: UICollectionViewCell {
    static let identifier = "FilterCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontKeys.robotoSerifRegular.rawValue, size: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .violet700 : .unselectedBG
            titleLabel.textColor = isSelected ? .white : .black
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        titleLabel.centerInSuperview()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with option: FilterOption) {
        titleLabel.text = option.title
        contentView.backgroundColor = option.isSelected ? .violet700 : .unselectedBG
        titleLabel.textColor = option.isSelected ? .white : .black
    }
}
