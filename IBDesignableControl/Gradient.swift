//
//  Gradient.swift
//  Convoz
//
//  Created by Nicolas Gomollon on 8/31/18.
//  Copyright © 2018 X Empire Inc. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public struct Gradient {
    
    public var colors: Array<CGColor>
    
    public var locations: Array<NSNumber>
    
}

extension UIColor {
    
    public convenience init(r: UInt8, g: UInt8, b: UInt8, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
}

public let SimpleWhiteGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 255, g: 255, b: 255, a: 1.0).cgColor,  /* #FFFFFF */
        UIColor(r: 255, g: 255, b: 255, a: 1.0).cgColor   /* #FFFFFF */
    ], locations: [
        0.0,
        1.0
    ])

public let BlackTabGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 60, g: 60, b: 60, a: 1.0).cgColor,  /* #3c3c3c */
        UIColor(r: 60, g: 60, b: 60, a: 1.0).cgColor   /* #3c3c3c */
    ], locations: [
        0.0,
        1.0
    ])

public let PurpleTabGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 82, g: 125, b: 231, a: 1.0).cgColor,  /* #527DE7 */
        UIColor(r: 164, g: 126, b: 234, a: 1.0).cgColor, /* #A47EEA */
        UIColor(r: 82, g: 125, b: 231, a: 1.0).cgColor   /* #527DE7 */
    ], locations: [
        0.0,
        0.5,
        1.0
    ])

public let GreenTabGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 191, g: 222, b: 105, a: 1.0).cgColor, /* #BFDE69 */
        UIColor(r: 111, g: 191, b: 130, a: 1.0).cgColor  /* #6FBF82 */
    ], locations: [
        0.0,
        1.0
    ])

public let GrayDisabledGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 207, g: 207, b: 207, a: 1.0).cgColor, /* #CFCFCF */
        UIColor(r: 207, g: 207, b: 207, a: 1.0).cgColor  /* #CFCFCF */
    ], locations: [
        0.0,
        1.0
    ])

public let SimpleGrayGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 162, g: 162, b: 162, a: 1.0).cgColor, /* #A2A2A2 */
        UIColor(r: 207, g: 207, b: 207, a: 1.0).cgColor  /* #CFCFCF */
    ], locations: [
        0.0,
        1.0
    ])

public let SimplePurpleGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 82, g: 125, b: 231, a: 1.0).cgColor, /* #527DE7 */
        UIColor(r: 146, g: 125, b: 233, a: 1.0).cgColor /* #927DE9 */
    ],
    locations: [
        0.0,
        1.0
    ])

public let SimpleGreenGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 111, g: 191, b: 130, a: 1.0).cgColor, /* #6FBF82 */
        UIColor(r: 172, g: 215, b: 111, a: 1.0).cgColor  /* #ACD76F */
    ], locations: [
        0.0,
        1.0
    ])

public let MessageGreenGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 0, g: 209, b: 0, a: 1.0).cgColor, /* #00d100 */
        UIColor(r: 0, g: 194, b: 63, a: 1.0).cgColor /* #00c23f */
    ], locations: [
        0.0,
        1.0
    ])

public let OrangeGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 238, g: 113, b: 77, a: 1.0).cgColor, /* #EE714D */
        UIColor(r: 10, g: 77, b: 34, a: 1.0).cgColor   /* #D74D22 */
    ], locations: [
        0.0,
        1.0
    ])

public let OnFireGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 255, g: 80, b: 104, a: 1.0).cgColor, /* #FF5068 */
        UIColor(r: 220, g: 41, b: 46, a: 1.0).cgColor   /* #DC292E */
    ], locations: [
        0.0,
        1.0
    ])

public let TwitterGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 29, g: 161, b: 242, a: 1.0).cgColor, /* #1DA1F2 */
        UIColor(r: 29, g: 161, b: 242, a: 1.0).cgColor  /* #1DA1F2 */
    ], locations: [
        0.0,
        1.0
    ])

public let FacebookGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 66, g: 103, b: 178, a: 1.0).cgColor, /* #4267B2 */
        UIColor(r: 66, g: 103, b: 178, a: 1.0).cgColor  /* #4267B2 */
    ], locations: [
        0.0,
        1.0
    ])

public let FacebookMessengerGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 0, g: 178, b: 255, a: 1.0).cgColor, /* #00B2FF */
        UIColor(r: 0, g: 106, b: 255, a: 1.0).cgColor  /* #006AFF */
    ], locations: [
        0.0,
        1.0
    ])

public let InstagramGradient: Gradient = Gradient(
    colors: [
        UIColor(r: 244, g: 0, b: 2, a: 1.0).cgColor,    /* #F40002 */
        UIColor(r: 207, g: 48, b: 127, a: 1.0).cgColor, /* #CF307F */
        UIColor(r: 187, g: 0, b: 172, a: 1.0).cgColor,  /* #BB00AC */
        UIColor(r: 122, g: 79, b: 186, a: 1.0).cgColor  /* #7A4FBA */
    ], locations: [
        0.0,
        0.25,
        0.5,
        1.0
    ])
