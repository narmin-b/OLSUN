//
//  AuthBackgroundView.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 25.03.25.
//

import UIKit

class GeometricBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShapes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShapes()
    }
    
    private func setupShapes() {
        addCircle(at: CGPoint(x: -300, y: -360), diameter: 520, color: UIColor.primaryHighlight)
        addCircle(at: CGPoint(x: -100, y: bounds.height - 140), diameter: 300, color: UIColor.primaryHighlight)
        addCircle(at: CGPoint(x: bounds.width - 70, y: 80), diameter: 340, color: UIColor.primaryHighlight)
    }
    
    private func addCircle(at position: CGPoint, diameter: CGFloat, color: UIColor) {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(ovalIn: CGRect(x: position.x, y: position.y, width: diameter, height: diameter))
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
        layer.addSublayer(shapeLayer)
    }
}
