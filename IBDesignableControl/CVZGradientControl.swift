//
//  CVZGradientControl.swift
//  IBDesignables
//
//  Created by Jitae Kim on 4/25/19.
//  Copyright © 2019 X Empire Inc. All rights reserved.
//

import UIKit

public class CVZGradientControl: IBDesignableControl {

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
            imageView.image = image
        }
    }
    
    @IBInspectable public var isLeftImagePosition: Bool = true {
        didSet {
            if !isLeftImagePosition {
                stackView.addArrangedSubview(imageContainerView)
            }
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 100.0, height: 40.0)
    }
    
    public override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    public override func setupViews() {
        layer.cornerRadius = cornerRadius
        titleLabel.text = text
        titleLabel.textColor = textColor
        imageView.image = image
        if !isLeftImagePosition {
            stackView.addArrangedSubview(imageContainerView)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = self.cornerRadius == 0 ? bounds.size.height / 2.0 : 0.0
    }

}
