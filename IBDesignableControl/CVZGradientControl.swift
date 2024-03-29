//
//  CVZGradientControl.swift
//  IBDesignables
//
//  Created by Jitae Kim on 4/25/19.
//  Copyright © 2019 X Empire Inc. All rights reserved.
//

import UIKit

public class CVZGradientControl: IBDesignableControl {

    public enum ButtonStyle: Int {
        case `default`
        case outline
    }
    
    public enum GradientDirection: Int {
        case horizontal
        case vertical
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable public var text: String? {
        didSet {
            titleLabel.text = text
            setNeedsLayout()
        }
    }
    
    public var attributedText: NSAttributedString? {
        get {
            return titleLabel.attributedText
        }
        set {
            titleLabel.attributedText = newValue
        }
    }
    
    @IBInspectable public var textColor: UIColor {
        get {
            return titleLabel.textColor
        }
        set {
            titleLabel.textColor = newValue
        }
    }
    
    public var textAlignment: NSTextAlignment {
        get {
            return titleLabel.textAlignment
        }
        set {
            titleLabel.textAlignment = newValue
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            imageView.tintColor = tintColor
            titleLabel.textColor = tintColor
        }
    }
    
    @IBInspectable public var image: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable public var isLeftImagePosition: Bool = true {
        didSet {
            if !isLeftImagePosition {
                stackView.addArrangedSubview(imageContainerView)
            }
        }
    }
    
    public var imagePadding: CGFloat = 0 {
        didSet {
            stackViewLeadingConstraint.constant = imagePadding
            stackViewTrailingConstraint.constant = imagePadding
            layoutIfNeeded()
        }
    }
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    public var gradientDirection: GradientDirection = .horizontal
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabelContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var isAnimating: Bool = false
    private var animationDelay: TimeInterval = 0.0

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 100.0, height: 40.0)
    }
    
    public override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            highlightView.alpha = isHighlighted ? 0.3 : 0.0
        }
    }
    
    internal var outlineWidth: CGFloat {
        return 2.0
    }
    
    private var outlinePath: UIBezierPath {
        let outlineRect: CGRect = bounds.insetBy(dx: outlineWidth, dy: outlineWidth)
        let cornerRadius: CGFloat = self.cornerRadius == 0 ? (outlineRect.size.height / 2.0) : 0.0
        return UIBezierPath(roundedRect: outlineRect, cornerRadius: cornerRadius)
    }
    
    private let outlineLayer: CAShapeLayer = {
        let outlineLayer: CAShapeLayer = .init()
        outlineLayer.strokeColor = UIColor.black.cgColor
        outlineLayer.fillColor = UIColor.clear.cgColor
        return outlineLayer
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = .init()
        gradientLayer.masksToBounds = true
        gradientLayer.needsDisplayOnBoundsChange = true
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()
    
    private let textGradientLayer: CAGradientLayer = {
        let textGradientLayer: CAGradientLayer = .init()
        textGradientLayer.masksToBounds = true
        textGradientLayer.needsDisplayOnBoundsChange = true
        textGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        textGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return textGradientLayer
    }()
    
    public var gradient: Gradient = OrangeGradient {
        didSet {
            restyleGradient()
        }
    }
    
    public var style: ButtonStyle = .default {
        didSet {
            updateButtonStyle()
        }
    }
    
    public var isLoading: Bool {
        return activityIndicator.isAnimating
    }
        
    public override func setupViews() {
        clipsToBounds = false
        layer.cornerRadius = cornerRadius
        titleLabel.text = text
        titleLabel.textColor = textColor
        updateImage()
        if !isLeftImagePosition {
            stackView.addArrangedSubview(imageContainerView)
        }
        configureGradient()
        restyleGradient()
        updateButtonStyle()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        cornerRadius = self.cornerRadius == 0 ? bounds.size.height / 2.0 : 0.0
        textGradientLayer.frame = titleLabelContainerView.bounds
        CATransaction.commit()
        updateButtonStyle()
    }
    
    private func configureGradient() {
        restyleGradient()
    }
    
    private func restyleGradient() {
        let startPoint: CGPoint
        let endPoint: CGPoint
        switch gradientDirection {
        case .horizontal:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
        case .vertical:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        gradientLayer.colors = gradient.colors
        gradientLayer.locations = gradient.locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        textGradientLayer.colors = gradient.colors
        textGradientLayer.locations = gradient.locations
        textGradientLayer.startPoint = startPoint
        textGradientLayer.endPoint = endPoint
    }
    
    private func updateImage() {
        imageView.image = image
        imageContainerView.isHidden = image == nil
    }

    private func updateButtonStyle() {
        switch style {
        case .default:
            outlineLayer.path = nil
            gradientLayer.mask = nil
            textGradientLayer.mask = nil
            gradientView.alpha = 1
            titleLabelContainerView.layer.mask = nil
            textGradientLayer.removeFromSuperlayer()
        case .outline:
            if textGradientLayer.superlayer == nil {
                titleLabelContainerView.layer.addSublayer(textGradientLayer)
                textGradientLayer.frame = titleLabelContainerView.bounds
            }
            outlineLayer.lineWidth = outlineWidth
            outlineLayer.path = outlinePath.cgPath
            gradientView.alpha = 0
            titleLabelContainerView.layer.mask = titleLabel.layer
        }
    }
    
    // MARK: Activity Indicator
    
    public func startLoading() {
        guard !isLoading else { return }
        isEnabled = false
        stackView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    public func finishLoading() {
        guard isLoading else { return }
        activityIndicator.stopAnimating()
        stackView.isHidden = false
        isEnabled = true
    }
    
    // MARK: Heartbeat Animation
    
    public func startAnimating() {
        guard !isAnimating else { return }
        isAnimating = true
        animation1()
        animationDelay = 1.5
    }
    
    public func stopAnimating() {
        guard isAnimating else { return }
        isAnimating = false
        animationDelay = 0.0
    }
    
    private func animation1() {
        guard isAnimating else { return }
        UIView.animate(withDuration: 0.25, delay: animationDelay, curve: .easeOut, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: animation2)
    }
    
    private func animation2() {
        UIView.animate(withDuration: 0.25, delay: 0.0, curve: .easeOut, options: [.allowUserInteraction], animations: {
            self.transform = .identity
        }, completion: animation3)
    }
    
    private func animation3() {
        guard isAnimating else { return }
        UIView.animate(withDuration: 0.25, delay: 0.0, curve: .easeOut, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: animation4)
    }
    
    private func animation4() {
        UIView.animate(withDuration: 0.25, delay: 0.0, curve: .easeOut, options: [.allowUserInteraction], animations: {
            self.transform = .identity
        }, completion: animation1)
    }
    
}
