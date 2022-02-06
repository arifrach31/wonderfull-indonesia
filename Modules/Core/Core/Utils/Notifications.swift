//
//  Notifications.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import Foundation

public struct Notifications {
  public static let favoritNotifications = NSNotification.Name(rawValue: "favoritNotifications")
}

public extension NSNotification.Name {
  func post(with object: Any? = nil) {
    NotificationCenter.default.post(name: self, object: object)
  }
}
