//
//  Constants.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import UIKit

struct Constants {
  static let applicationName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "-"
  static let applicationVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
  static let applicationBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
  static let iosVersion = UIDevice.current.systemVersion
    
  static var deviceIdentifier: String {
    // swiftlint:disable implicit_getter
    get {
      if let uid = Persistent.shared.get(key: .deviceID) {
        return uid
      } else {
        if let uid = UIDevice.current.identifierForVendor?.uuidString {
          Persistent.shared.set(key: .deviceID, value: uid)
          return uid
        }
        
        return "application_generated_device_id"
      }
    }
  }
  
  static var screenWidth: CGFloat {
    get {
      if UIDevice.current.orientation.isLandscape {
        return max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
      } else {
        return min(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
      }
    }
  }
}
