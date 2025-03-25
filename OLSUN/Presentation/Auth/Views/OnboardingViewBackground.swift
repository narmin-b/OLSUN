//
//  OnboardingViewBackground.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 25.03.25.
//

import UIKit

class OnboardingViewBackground: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShapes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShapes()
    }
    
    private func setupShapes() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let smallScreen = screenWidth <= 375
        let largeScreen = screenWidth > 460
        
        let scaleFactor: CGFloat = smallScreen ? 0.85 : (largeScreen ? 1.2 : 1.0)

        addCircle(at: CGPoint(x: -screenWidth * 0.4, y: -screenHeight * 0.15),
                  diameter: screenWidth * 0.9 * scaleFactor,
                  color: UIColor.primaryHighlight)

        addCircle(at: CGPoint(x: screenWidth - screenWidth * 0.15, y: screenHeight * 0.25),
                  diameter: screenWidth * 0.7 * scaleFactor,
                  color: UIColor.primaryHighlight)
    }
    
    private func addCircle(at position: CGPoint, diameter: CGFloat, color: UIColor) {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(ovalIn: CGRect(x: position.x, y: position.y, width: diameter, height: diameter))
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
        layer.addSublayer(shapeLayer)
    }
}

