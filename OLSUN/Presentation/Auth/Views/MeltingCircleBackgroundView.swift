//
//  AuthBackgroundView.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 25.03.25.
//

import UIKit

class MeltingCircleBackgroundView: UIView {

    var circleColor: UIColor = UIColor(red: 0.99, green: 0.85, blue: 0.89, alpha: 1.0)
    var fadeHeight: CGFloat = UIScreen.main.bounds.height > 700 ? 140 : 100

    private var circleView: UIView?
    private var gradientLayer: CAGradientLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if circleView == nil {
            setupCircle()
        }

        if gradientLayer == nil {
            setupFade()
        }
    }

    private func setupCircle() {
        let circleSize: CGFloat = bounds.height > 700 ? bounds.width * 2.2 : bounds.width * 1.8
        let circle = UIView()
        circle.backgroundColor = circleColor
        circle.frame = CGRect(
            x: -(circleSize - bounds.width) / 2,
            y: -circleSize * 0.3,
            width: circleSize,
            height: circleSize
        )
        circle.layer.cornerRadius = circleSize / 2
        circle.clipsToBounds = true

        addSubview(circle)
        circleView = circle
    }

    private func setupFade() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(
            x: 0,
            y: bounds.height - fadeHeight*2.5,
            width: bounds.width,
            height: fadeHeight
        )
        gradient.colors = [
            circleColor.cgColor,
            UIColor.white.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)

        layer.addSublayer(gradient)
        gradientLayer = gradient
    }
}
