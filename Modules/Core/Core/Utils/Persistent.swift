//
//  Persistent.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import Foundation

public enum PersistentKey: String, StorageTypeProtocol {
  case deviceID         = "deviceID"
  case sessionID        = "session_id"
  case destination      = "destination"
  case firstInstall     = "first_install"
  
  var storageType: PersistentStorageType {
    // swiftlint:disable implicit_getter
    get {
      switch self {
      case .deviceID:
        return .keychain
      default:
        return .userDefault
      }
    }
  }
}

protocol StorageTypeProtocol {
  var storageType: PersistentStorageType { get }
}

extension PersistentKey {
  private func getPrefix() -> String {
    #if DEVELOPMENT
      return "dev_"
    #elseif STAGING
      return "stg_"
    #else
      return "prod_"
    #endif
  }
  
  func modifiedKey() -> String {
    return getPrefix() + self.rawValue
  }
}

enum PersistentStorageType {
  case userDefault
  case keychain
}

public struct Persistent {
  public static let shared = Persistent()
  private let keychain = KeychainSwift()
  
  public func set(key: PersistentKey, value: String) {
    let storage = key.storageType
    
    if storage == .keychain {
      _ = keychain.set(value, forKey: key.modifiedKey())
    } else {
      UserDefaults.set(value, forKey: key.modifiedKey())
    }
  }
  
  public func get(key: PersistentKey) -> String? {
    let storage = key.storageType
    
    if storage == .keychain {
      return keychain.get(key.modifiedKey())
    } else {
      return UserDefaults.get(key.modifiedKey())
    }
  }
  
  public func delete(key: PersistentKey) {
    let storage = key.storageType
    
    if storage == .keychain {
      _ = keychain.delete(key.modifiedKey())
    } else {
      UserDefaults.delete(key.modifiedKey())
    }
  }
}
