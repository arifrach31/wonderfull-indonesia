//
//  String.swift
//  Common
//
//  Created by ArifRachman on 06/02/22.
//

import Foundation

extension String {
  public func localized(identifier: String) -> String {
    let bundle = Bundle(identifier: identifier) ?? .main
    return bundle.localizedString(forKey: self, value: nil, table: nil)
  }
}
