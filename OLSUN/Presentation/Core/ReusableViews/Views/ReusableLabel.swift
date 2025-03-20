//
//  ReusableLabel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import UIKit

class ReusableLabel: UILabel {
    private var labelText: String!
    private var labelColor: UIColor
    private var labelFont: FontKeys
    private var labelSize: CGFloat
    private var numOfLines: Int
    private var bgColor: UIColor
    
    init(
        labelText: String!,
        labelColor: UIColor = .black,
        labelFont: FontKeys = .workSansMedium,
        labelSize: CGFloat = 16,
        numOfLines: Int = 1,
        bgColor: UIColor = .clear
    ) {
        self.labelText = labelText
        self.labelColor = labelColor
        self.labelFont = labelFont
        self.labelSize = labelSize
        self.numOfLines = numOfLines
        self.bgColor = bgColor
        super.init(frame: .zero)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        text = labelText
        textColor = labelColor
        textAlignment = .left
        font = UIFont(name: labelFont.rawValue, size: labelSize)
        numberOfLines = numOfLines
        backgroundColor = bgColor
    }
}
