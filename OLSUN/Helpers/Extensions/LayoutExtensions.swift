//
//  LayoutExtensions.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import UIKit

extension UIEdgeInsets {
    // Initialize UIEdgeInsets with equal padding for all sides
    public init(all value: CGFloat) {
        self = .init(top: value, left: value, bottom: -value, right: -value)
    }
    
    // Initialize UIEdgeInsets with individual padding values for each side
    public init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self = .init(top: top, left: leading, bottom: bottom, right: trailing)
    }
    
    // Initialize UIEdgeInsets with equal vertical and horizontal padding
    public init(y: CGFloat = 0, x: CGFloat = 0) {
        self = .init(top: y, left: x, bottom: -y, right: -x)
    }
    
    // Initialize UIEdgeInsets with specified top, horizontal, and bottom padding
    public init(top: CGFloat = 0, x: CGFloat, bottom: CGFloat = 0) {
        self = .init(top: top, left: x, bottom: bottom, right: -x)
    }
}

// MARK: - UIView Extension
extension UIView {
    
    /// Anchors the view to specified anchors with padding and size
    public func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        widthLessThanOrEqual: NSLayoutXAxisAnchor? = nil,
        bottomGreaterThanOrEqual: NSLayoutYAxisAnchor? = nil,
        padding: UIEdgeInsets = .zero,
        widthLessThanOrEqualToConstant: CGFloat? = nil,
        widthGreaterThanOrEqualToConstant: CGFloat? = nil,
        widthWithMultiplier: NSLayoutDimension? = nil,
        heightWithMultiplier: NSLayoutDimension? = nil,
        size: CGSize = .zero,
        multiplier: CGFloat = 1
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top {
            topAnchor.constraint(
                equalTo: top,
                constant: padding.top
            ).isActive = true
        }
        
        if let leading {
            leadingAnchor.constraint(
                equalTo: leading,
                constant: padding.left
            ).isActive = true
        }
        
        if let bottom {
            bottomAnchor.constraint(
                equalTo: bottom,
                constant: padding.bottom
            ).isActive = true
        }
        
        if let trailing {
            trailingAnchor.constraint(
                equalTo: trailing,
                constant: padding.right
            ).isActive = true
        }
        
        if let _ =  widthLessThanOrEqual {
            widthAnchor.constraint(lessThanOrEqualToConstant: size.width).isActive = true
        }
        
        if let widthWithMultiplier {
            widthAnchor.constraint(equalTo: widthWithMultiplier, multiplier: multiplier).isActive = true
        }
        
        if let heightWithMultiplier {
            heightAnchor.constraint(equalTo: heightWithMultiplier, multiplier: multiplier).isActive = true
        }
        
        if let bottomGreaterThanOrEqual {
            bottomAnchor.constraint(greaterThanOrEqualTo: bottomGreaterThanOrEqual, constant: padding.bottom).isActive = true
        }
        
        if let widthLessThanOrEqualToConstant {
            widthAnchor.constraint(lessThanOrEqualToConstant: widthLessThanOrEqualToConstant).isActive = true
        }
        
        if let widthGreaterThanOrEqualToConstant {
            widthAnchor.constraint(greaterThanOrEqualToConstant: widthGreaterThanOrEqualToConstant).isActive = true
        }
        
        widthAnchor.constraint(
            equalToConstant: size.width
        ).isActive = size.width != 0
        heightAnchor.constraint(
            equalToConstant: size.height
        ).isActive = size.height != 0
    }
    
    /// Anchors the view to its superview with specified sides and padding
    public func anchorSuperview(top: Bool = false,
                                leading: Bool = false,
                                bottom: Bool = false,
                                trailing: Bool = false,
                                padding: UIEdgeInsets = .zero,
                                size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(
            equalTo: superview!.topAnchor,
            constant: padding.top
        ).isActive = top
        leadingAnchor.constraint(
            equalTo: superview!.leadingAnchor,
            constant: padding.left
        ).isActive = leading
        bottomAnchor.constraint(
            equalTo: superview!.bottomAnchor,
            constant: padding.bottom
        ).isActive = bottom
        trailingAnchor.constraint(
            equalTo: superview!.trailingAnchor,
            constant: padding.right
        ).isActive = trailing
        widthAnchor.constraint(
            equalToConstant: size.width
        ).isActive = size.width != 0
        heightAnchor.constraint(
            equalToConstant: size.height
        ).isActive = size.height != 0
    }
    
    /// Fills the view to its superview with specified padding
    public func fillSuperview(padding: UIEdgeInsets = .zero) {
        anchor(
            top: superview?.topAnchor,
            leading: superview?.leadingAnchor,
            bottom: superview?.bottomAnchor,
            trailing: superview?.trailingAnchor,
            padding: padding
        )
    }
    
    /// Fills the view to its superview's safe area layout guide with specified padding
    public func fillSuperviewSafeAreaLayoutGuide(padding: UIEdgeInsets = .zero) {
        anchor(
            top: superview?.safeAreaLayoutGuide.topAnchor,
            leading: superview?.safeAreaLayoutGuide.leadingAnchor,
            bottom: superview?.safeAreaLayoutGuide.bottomAnchor,
            trailing: superview?.safeAreaLayoutGuide.trailingAnchor,
            padding: padding
        )
    }
    
    /// Anchors the view's size to a specified size
    public func anchorSize(_ size: CGSize) {
        widthAnchor.constraint(
            equalToConstant: size.width
        ).isActive = size.width != 0
        heightAnchor.constraint(
            equalToConstant: size.height
        ).isActive = size.height != 0
    }
    
    /// Anchors the view's size to another view's size
    public func anchorSize(to view: UIView) {
        widthAnchor.constraint(
            equalTo: view.widthAnchor
        ).isActive = true
        heightAnchor.constraint(
            equalTo: view.heightAnchor
        ).isActive = true
    }
    
    /// Anchors the view's width to another view's width
    public func anchorWidth(to view: UIView) {
        widthAnchor.constraint(
            equalTo: view.widthAnchor
        ).isActive = true
    }
    
    /// Anchors the view's height to another view's height
    public func anchorHeight(to view: UIView) {
        heightAnchor.constraint(
            equalTo: view.heightAnchor
        ).isActive = true
    }
    
    /// Centers the view in its superview with optional size and offsets
    public func centerInSuperview(
        size: CGSize = .zero,
        xConstant: CGFloat = 0,
        yConstant: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(
                equalTo: superviewCenterXAnchor,
                constant: xConstant
            ).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(
                equalTo: superviewCenterYAnchor,
                constant: yConstant
            ).isActive = true
        }
        widthAnchor.constraint(
            equalToConstant: size.width
        ).isActive = size.width != 0
        heightAnchor.constraint(
            equalToConstant: size.height
        ).isActive = size.height != 0
    }
    
    /// Centers the view to another view with optional size and offsets
    public func centerToView(
        to view: UIView,
        size: CGSize = .zero,
        xConstant: CGFloat = 0,
        yConstant: CGFloat = 0) {
            translatesAutoresizingMaskIntoConstraints = false
            centerXAnchor.constraint(
                equalTo: view.centerXAnchor,
                constant: xConstant
            ).isActive = true
            centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: yConstant
            ).isActive = true
            widthAnchor.constraint(
                equalToConstant: size.width
            ).isActive = size.width != 0
            heightAnchor.constraint(
                equalToConstant: size.height
            ).isActive = size.height != 0
        }
    
    public func centerYToView(
        to view: UIView,
        size: CGSize = .zero,
        yConstant: CGFloat = 0) {
            translatesAutoresizingMaskIntoConstraints = false
            centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: yConstant
            ).isActive = true
            widthAnchor.constraint(
                equalToConstant: size.width
            ).isActive = size.width != 0
            heightAnchor.constraint(
                equalToConstant: size.height
            ).isActive = size.height != 0
        }
    
    public func centerXToView(
        to view: UIView,
        size: CGSize = .zero,
        xConstant: CGFloat = 0) {
            translatesAutoresizingMaskIntoConstraints = false
            centerXAnchor.constraint(
                equalTo: view.centerXAnchor,
                constant: xConstant
            ).isActive = true
            widthAnchor.constraint(
                equalToConstant: size.width
            ).isActive = size.width != 0
            heightAnchor.constraint(
                equalToConstant: size.height
            ).isActive = size.height != 0
        }
    
    /// Centers the view's X-axis to its superview with optional offset
    public func centerXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(
                equalTo: superviewCenterXAnchor,
                constant: constant).isActive = true
        }
    }
    
    /// Centers the view's Y-axis to its superview with optional offset
    public func centerYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(
                equalTo: superviewCenterYAnchor,
                constant: constant
            ).isActive = true
        }
    }
}
