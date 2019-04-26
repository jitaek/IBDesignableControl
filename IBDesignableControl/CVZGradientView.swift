//
//  CVZGradientView.swift
//  Convoz
//
//  Created by Jitae Kim on 2/25/19.
//  Copyright © 2019 X Empire Inc. All rights reserved.
//

import UIKit

class CVZGradientView: UIView {

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = .init()
        gradientLayer.masksToBounds = true
        gradientLayer.needsDisplayOnBoundsChange = true
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()
    
    public var gradient: Gradient = OrangeGradient {
        didSet {
            updateStyle()
        }
    }
    
    public var roundedCorners: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = false
        backgroundColor = .clear
        configureGradient()
        updateStyle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        let cornerRadius: CGFloat = roundedCorners ? (bounds.size.height / 2.0) : 0.0
        gradientLayer.cornerRadius = cornerRadius
    }
    
    private func configureGradient() {
        gradientLayer.frame = layer.bounds
        restyleGradient()
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func restyleGradient() {
        gradientLayer.colors = gradient.colors
        gradientLayer.locations = gradient.locations
    }
    
    private func updateStyle() {
        restyleGradient()
    }
}
