//
//  ReusableButton.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import UIKit

class ReusableButton: UIButton {
    private var title: String!
    private var cornerRad: CGFloat
    private var bgColor: UIColor
    private var titleColor: UIColor
    private var titleSize: CGFloat
    private var titleFont: FontKeys
    private var onAction: (() -> Void)
    private var borderColor: UIColor
    private var borderWidth: CGFloat
    
    init(
        title: String!,
        onAction: (@escaping () -> Void),
        cornerRad: CGFloat = 8,
        bgColor: UIColor = .primaryHighlight,
        titleColor: UIColor = .backgroundMain,
        titleSize: CGFloat = 16,
        titleFont: FontKeys = .interRegular,
        borderColor: UIColor = .clear,
        borderWidth: CGFloat = 0
    ) {
        self.title = title
        self.onAction = onAction
        self.bgColor = bgColor
        self.cornerRad = cornerRad
        self.titleColor = titleColor
        self.titleSize = titleSize
        self.titleFont = titleFont
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        setAttributedTitle(NSAttributedString(string: title, attributes: [.font: UIFont(name: titleFont.rawValue, size: titleSize)!]), for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = bgColor
        layer.cornerRadius = cornerRad
        titleLabel?.textAlignment = .center
        layer.masksToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
       
    @objc private func buttonTapped() {
        onAction()
    }
}
