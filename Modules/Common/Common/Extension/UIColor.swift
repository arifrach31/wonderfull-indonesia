//
//  UIColor.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import UIKit
import Foundation

public extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(netHex: Int) {
    self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
  }
  
  static let primaryColor = UIColor(netHex: 0x42A8E5)
  static let secondaryColor = UIColor(netHex: 0x2B467B)
  static let greyColor = UIColor(netHex: 0x8D8D8D)
  static let primaryViewBackgroundColor = UIColor(netHex: 0xE9F4FF)
  static let lineColor = UIColor(netHex: 0xcccccc)
  
  static var gradientColorPrimary: CAGradientLayer {
    let grad = CAGradientLayer()
    grad.colors = [UIColor.primaryViewBackgroundColor.cgColor, UIColor.white.cgColor]
    grad.startPoint = CGPoint(x: 0, y: 0)
    grad.endPoint = CGPoint(x: 0, y: 1)
    return grad
  }

  static var gradientColorAbout: CAGradientLayer {
    let grad = CAGradientLayer()
    grad.colors = [UIColor.primaryColor.cgColor, UIColor.white.cgColor]
    grad.startPoint = CGPoint(x: 0, y: 0.1)
    grad.endPoint = CGPoint(x: 0.1, y: 0.7)
    return grad
  }
  
  var random: UIColor {
    let r = Int(arc4random_uniform(255))
    let g = Int(arc4random_uniform(255))
    let b = Int(arc4random_uniform(255))
    return UIColor(red: r, green: g, blue: b)
  }
}
