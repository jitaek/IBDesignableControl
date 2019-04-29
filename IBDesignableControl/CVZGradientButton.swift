//
//  CVZGradientButton.swift
//  Convoz
//
//  Created by Nicolas Gomollon on 10/22/18.
//  Copyright © 2018 X Empire Inc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class CVZGradientButton: UIButton {
    
    public enum ButtonStyle: Int {
        case `default`
        case outline
    }
    
    public enum GradientDirection: Int {
        case horizontal
        case vertical
    }
    
    public enum ImagePosition: Int {
        case left
        case right
    }
    
    public enum TextCentering: Int {
        case absolute
        case relative
    }
    
    private var isAnimating: Bool = false
    private var animationDelay: TimeInterval = 0.0
    
    private var activityIndicator: UIActivityIndicatorView?
    
    internal var outlineWidth: CGFloat {
        return 2.0
    }
    
    private var outlinePath: UIBezierPath {
        let outlineRect: CGRect = bounds.insetBy(dx: outlineWidth, dy: outlineWidth)
        let cornerRadius: CGFloat = roundedCorners ? (outlineRect.size.height / 2.0) : 0.0
        guard cornerRadius > 0.0 else {
            return UIBezierPath(rect: outlineRect)
        }
        return UIBezierPath(roundedRect: outlineRect, cornerRadius: cornerRadius)
    }
    
    private let outlineLayer: CAShapeLayer = {
        let outlineLayer: CAShapeLayer = .init()
        outlineLayer.strokeColor = UIColor.black.cgColor
        outlineLayer.fillColor = UIColor.clear.cgColor
        return outlineLayer
    }()
    
    private let textLabel: UILabel = {
        let textLabel: UILabel = .init(frame: .zero)
        textLabel.backgroundColor = .clear
        textLabel.textAlignment = .center
        return textLabel
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
    
    private let highlightView: UIView = {
        let highlightView: UIView = .init(frame: .zero)
        highlightView.backgroundColor = .black
        highlightView.alpha = 0.0
        highlightView.clipsToBounds = true
        highlightView.translatesAutoresizingMaskIntoConstraints = false
        return highlightView
    }()
    
    public var gradient: Gradient = OrangeGradient {
        didSet {
            updateStyle()
        }
    }
    
    public var gradientDirection: GradientDirection = .horizontal {
        didSet {
            updateStyle()
        }
    }
    
    public var textColor: UIColor = .white {
        didSet {
            setTitleColor(textColor, for: .normal)
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            setTitleColor(tintColor, for: .normal)
        }
    }
    
    public var imagePosition: ImagePosition = .left {
        didSet {
            updateImagePosition()
            setNeedsLayout()
        }
    }
    
    public var imagePadding: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var image: UIImage? {
        get {
            return currentImage
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    public var textCentering: TextCentering = .relative {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var textFont: UIFont? {
        get {
            return titleLabel?.font
        }
        set {
            titleLabel?.font = newValue
        }
    }
    
    public var text: String? {
        get {
            return currentTitle
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    public var attributedText: NSAttributedString? {
        get {
            return currentAttributedTitle
        }
        set {
            setAttributedTitle(newValue, for: .normal)
        }
    }
    
    public var roundedCorners: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var style: ButtonStyle = .default {
        didSet {
            updateButtonStyle()
        }
    }
    
    public var isLoading: Bool {
        return activityIndicator != nil
    }
    
    public override var isEnabled: Bool {
        didSet {
            updateStyle()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        var contentSize: CGSize = super.intrinsicContentSize
        contentSize.width += imagePadding
        return contentSize
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    internal func commonInit() {
        clipsToBounds = false
        tintColor = .white
        backgroundColor = .clear
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
        
        setTitleColor(.white, for: .normal)
        configureGradient()
        if let imageView: UIImageView = self.imageView {
            bringSubviewToFront(imageView)
        }
        updateStyle()
        updateImagePosition()
        
        addSubview(highlightView)
        NSLayoutConstraint.activate([
            highlightView.topAnchor.constraint(equalTo: topAnchor),
            highlightView.rightAnchor.constraint(equalTo: rightAnchor),
            highlightView.bottomAnchor.constraint(equalTo: bottomAnchor),
            highlightView.leftAnchor.constraint(equalTo: leftAnchor)])
        
        addTarget(self, action: #selector(onTouchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(onTouchUp), for: [.touchUpInside, .touchUpOutside, .touchDragExit, .touchCancel])
    }
    
    @objc private func onTouchDown() {
        highlightView.alpha = 0.3
    }
    
    @objc private func onTouchUp() {
        highlightView.alpha = 0.0
    }
    
    private func updateStyle() {
        restyleGradient()
        alpha = isEnabled ? 1.0 : 0.5
    }
    
    private func configureGradient() {
        gradientLayer.frame = layer.bounds
        textGradientLayer.frame = layer.bounds
        restyleGradient()
        layer.insertSublayer(gradientLayer, at: 0)
        layer.insertSublayer(textGradientLayer, at: 1)
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
    
    private func updateButtonStyle() {
        switch style {
        case .default:
            outlineLayer.path = nil
            gradientLayer.mask = nil
            textGradientLayer.mask = nil
        case .outline:
            textLabel.font = titleLabel?.font
            textLabel.text = titleLabel?.text
            textLabel.frame = titleRect(forContentRect: contentRect(forBounds: bounds))
            outlineLayer.lineWidth = outlineWidth
            outlineLayer.path = outlinePath.cgPath
            gradientLayer.mask = outlineLayer
            textGradientLayer.mask = textLabel.layer
        }
    }
    
    private func updateImagePosition() {
        switch UIApplication.shared.userInterfaceLayoutDirection {
        case .leftToRight:
            switch imagePosition {
            case .left:
                semanticContentAttribute = .forceLeftToRight
            case .right:
                semanticContentAttribute = .forceRightToLeft
            }
        case .rightToLeft:
            switch imagePosition {
            case .left:
                semanticContentAttribute = .forceRightToLeft
            case .right:
                semanticContentAttribute = .forceLeftToRight
            }
        @unknown default:
            break
        }
    }
    
    internal func setContentEdgeInsets() {
        let xPadding: CGFloat = imagePadding
        if (currentImage != nil) && (currentTitle != nil) {
            contentEdgeInsets = UIEdgeInsets(top: 0.0, left: xPadding, bottom: 0.0, right: xPadding)
        } else {
            contentEdgeInsets = .zero
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(highlightView)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        textGradientLayer.frame = bounds
        let cornerRadius: CGFloat = roundedCorners ? (bounds.size.height / 2.0) : 0.0
        gradientLayer.cornerRadius = cornerRadius
        textGradientLayer.cornerRadius = cornerRadius
        highlightView.layer.cornerRadius = cornerRadius
        CATransaction.commit()
        if (currentImage != nil) && (currentTitle != nil) {
            switch imagePosition {
            case .left:
                contentHorizontalAlignment = .left
            case .right:
                contentHorizontalAlignment = .right
            }
        } else {
            contentHorizontalAlignment = .center
        }
        setContentEdgeInsets()
        titleLabel?.alpha = (isLoading || (style == .outline)) ? 0.0 : 1.0
        imageView?.alpha = isLoading ? 0.0 : 1.0
        updateButtonStyle()
    }
    
    public override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        guard currentImage != nil,
            currentTitle != nil else {
                return super.titleRect(forContentRect: contentRect)
        }
        let titleRect: CGRect = super.titleRect(forContentRect: contentRect)
        let imageSize: CGSize = currentImage?.size ?? .zero
        let imageOffset: CGFloat
        switch textCentering {
        case .absolute:
            imageOffset = (imageSize.width * 2.0)
        case .relative:
            imageOffset = imageSize.width
        }
        let availableWidth: CGFloat = contentRect.width - imageOffset - titleRect.width
        let direction: CGFloat
        switch imagePosition {
        case .left:
            direction = 1.0
        case .right:
            direction = -1.0
        }
        return titleRect.offsetBy(dx: round(availableWidth / 2.0) * direction, dy: 0.0)
    }
    
    // MARK: Activity Indicator
    
    public func startLoading() {
        guard !isLoading else { return }
        isEnabled = false
        titleLabel?.alpha = 0.0
        imageView?.alpha = 0.0
        createActivityIndicator()
        layoutIfNeeded()
    }
    
    public func finishLoading() {
        guard isLoading else { return }
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
        layoutIfNeeded()
        isEnabled = true
        titleLabel?.alpha = 1.0
        imageView?.alpha = 1.0
    }
    
    private func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .white)
        guard let activityIndicator = self.activityIndicator else { return }
        activityIndicator.center = CGPoint(x: (frame.size.width / 2.0), y: (frame.size.height / 2.0))
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
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

public enum CVZViewAnimationCurve {
    
    case easeInOut
    case easeIn
    case easeOut
    case linear
    case function(CAMediaTimingFunction)
    case controlPoints(Float, Float, Float, Float)
    
    public func toOptions() -> UIView.AnimationOptions? {
        switch self {
        case .easeInOut:
            return .curveEaseInOut
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .linear:
            return .curveLinear
        default:
            return nil
        }
    }
    
    public func toCurve() -> UIView.AnimationCurve? {
        switch self {
        case .easeInOut:
            return .easeInOut
        case .easeIn:
            return .easeIn
        case .easeOut:
            return .easeOut
        case .linear:
            return .linear
        default:
            return nil
        }
    }
    
}

extension UIView {
    
    public class func animate(withDuration duration: TimeInterval, delay: TimeInterval, curve: CVZViewAnimationCurve = .easeInOut, options: UIView.AnimationOptions = [], animations: @escaping () -> Void, completion: @escaping () -> Void = {}) {
        var options: UIView.AnimationOptions = options.subtracting([.curveEaseInOut, .curveEaseIn, .curveEaseOut, .curveLinear])
        CATransaction.begin()
        switch curve {
        case .controlPoints(let c1x, let c1y, let c2x, let c2y):
            CATransaction.setAnimationTimingFunction(.init(controlPoints: c1x, c1y, c2x, c2y))
        case .function(let timingFunction):
            CATransaction.setAnimationTimingFunction(timingFunction)
        default:
            guard let opt = curve.toOptions() else { break }
            options.insert(opt)
        }
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations) { (finished: Bool) in
            completion()
        }
        CATransaction.commit()
    }
    
}
