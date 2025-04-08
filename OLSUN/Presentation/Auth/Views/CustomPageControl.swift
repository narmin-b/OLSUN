//
//  CustomPageControl.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 08.04.25.
//

import UIKit

final class CustomPageControl: UIStackView {
    var numberOfPages: Int = 0 {
        didSet {
            setupDots()
        }
    }

    var currentPage: Int = 0 {
        didSet {
            updateDots()
        }
    }

    private let activeColor = UIColor.black
    private let inactiveColor = UIColor.lightGray

    private var dotViews: [UIView] = []
    private var widthConstraints: [NSLayoutConstraint] = []

    private func setupDots() {
        arrangedSubviews.forEach { removeArrangedSubview($0); $0.removeFromSuperview() }
        dotViews.removeAll()
        widthConstraints.removeAll()

        for index in 0..<numberOfPages {
            let dot = UIView()
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.heightAnchor.constraint(equalToConstant: 12).isActive = true
            let width = index == currentPage ? 24 : 12
            let widthConstraint = dot.widthAnchor.constraint(equalToConstant: CGFloat(width))
            widthConstraint.isActive = true

            dot.layer.cornerRadius = 6
            dot.backgroundColor = index == currentPage ? activeColor : inactiveColor

            addArrangedSubview(dot)
            dotViews.append(dot)
            widthConstraints.append(widthConstraint)
        }

        spacing = 8
        alignment = .center
        distribution = .equalSpacing
    }

    private func updateDots() {
        for (index, dot) in dotViews.enumerated() {
            let isActive = index == currentPage
            dot.backgroundColor = isActive ? activeColor : inactiveColor

            widthConstraints[index].constant = isActive ? 24 : 12
            dot.layer.cornerRadius = 6
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
