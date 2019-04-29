//
//  IBDesignableControl.swift
//  IBDesignables
//
//  Created by Jitae Kim on 4/25/19.
//  Copyright © 2019 X Empire Inc. All rights reserved.
//

import UIKit

@IBDesignable
open class IBDesignableControl: UIControl {

    @IBOutlet var contentView: UIView!
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
        setupViews()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupXib()
        setupViews()
        contentView.prepareForInterfaceBuilder()
    }
    
    private func setupXib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        contentView = view
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
    }
    
    // Override this to provide finishing touches to view
    open func setupViews() {
        
    }
    
}
