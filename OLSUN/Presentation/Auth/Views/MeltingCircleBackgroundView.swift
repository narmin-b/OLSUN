//
//  AuthBackgroundView.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 25.03.25.
//

import UIKit

//class MeltingCircleBackgroundView: UIView {
//
//    // MARK: - Customization
//    var circleColor: UIColor = UIColor(red: 0.99, green: 0.85, blue: 0.89, alpha: 1.0) // #FCD8E4
//    var fadeHeight: CGFloat = 140
//
//    // MARK: - Init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//
//    // MARK: - Setup
//    private func setupView() {
//        backgroundColor = .clear
//        setupCircle()
//        setupFade()
//    }
//
//    private func setupCircle() {
//        let circleSize: CGFloat = bounds.width * 2.2
//
//        let circleView = UIView()
//        circleView.backgroundColor = circleColor
//        circleView.frame = CGRect(
//            x: -(circleSize - bounds.width) / 2,
//            y: -circleSize * 0.3,
//            width: circleSize,
//            height: circleSize
//        )
//        circleView.layer.cornerRadius = circleSize / 2
//        circleView.clipsToBounds = true
//
//        addSubview(circleView)
//    }
//
//    private func setupFade() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect(
//            x: 0,
//            y: bounds.height - fadeHeight,
//            width: bounds.width,
//            height: fadeHeight
//        )
//        gradientLayer.colors = [
//            circleColor.cgColor,
//            UIColor.white.cgColor
//        ]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//
//        layer.addSublayer(gradientLayer)
//    }
//}

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
