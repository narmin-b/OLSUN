//
//  PartnerSectionHeader.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import Foundation
import UIKit

final class PartnerSectionHeader: UICollectionReusableView {
    private lazy var titleListLabel: UILabel = {
        let label = ReusableLabel(
            labelText: "Qalereya",
            labelColor: .black,
            labelFont: .montserratMedium,
            labelSize:  DeviceSizeClass.current == .iPad ? 32 : 24
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    private lazy var topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var seeAllButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstrains()
    }
    
    func setUpConstrains() {
        addSubViews(topBorder, titleListLabel)
        
        topBorder.anchorSize(.init(width: 0, height: 4))
        topBorder.anchor(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            trailing: self.trailingAnchor,
            padding: .init(top: 0, left: -16, bottom: 0, right: 16)
        )
        titleListLabel.anchor(
            top: topBorder.bottomAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            padding: .init(top: 12, left: 0, bottom: 0, right: 0)
        )
    }
    
    func configure(with title: String) {
        titleListLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
