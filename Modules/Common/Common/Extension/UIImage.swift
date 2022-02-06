//
//  UIImage.swift
//  Common
//
//  Created by ArifRachman on 06/02/22.
//

import Foundation
import UIKit

public extension UIImage {
  static let bundle = Bundle(identifier: "com.wonderfull.indonesia.Common")
  static let shimmerHome = UIImage(named: "shimmer-home",
                                   in: bundle, compatibleWith: nil)
  static let iconHomeActive = UIImage(named: "icon-home-active",
                                      in: bundle, compatibleWith: nil)
  static let iconHomeInactive = UIImage(named: "icon-home-inactive",
                                        in: bundle, compatibleWith: nil)
  static let iconFavoritActive = UIImage(named: "icon-favorit-active",
                                         in: bundle, compatibleWith: nil)
  static let iconFavoritInactive = UIImage(named: "icon-favorit-inactive",
                                           in: bundle, compatibleWith: nil)
  static let iconAboutInactive = UIImage(named: "icon-about-inactive",
                                         in: bundle, compatibleWith: nil)
  static let iconAboutActive = UIImage(named: "icon-about-active",
                                       in: bundle, compatibleWith: nil)
  static let iconIsFavoritActive = UIImage(named: "icon-isfavorit-active",
                                           in: bundle, compatibleWith: nil)
  static let iconIsFavoritInactive = UIImage(named: "icon-isfavorit-inactive",
                                             in: bundle, compatibleWith: nil)
  static let iconBackBlack = UIImage(named: "icon-back-black",
                                     in: bundle, compatibleWith: nil)
  static let iconFindPlace = UIImage(named: "icon-find-place",
                                     in: bundle, compatibleWith: nil)
  static let iconWeather = UIImage(named: "icon-weather",
                                   in: bundle, compatibleWith: nil)
  static let iconPriceTag = UIImage(named: "icon-price-tag",
                                    in: bundle, compatibleWith: nil)
  static let coverSearch = UIImage(named: "cover-search",
                                   in: bundle, compatibleWith: nil)
  static let iconLocation = UIImage(named: "icon-location",
                                    in: bundle, compatibleWith: nil)
}
