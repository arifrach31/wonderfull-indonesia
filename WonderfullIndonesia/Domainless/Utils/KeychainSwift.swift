//
// Keychain helper for iOS/Swift.
//
// https://github.com/marketplacer/keychain-swift
//
// This file was automatically generated by combining multiple Swift source files.
//

// ----------------------------
//
// KeychainSwift.swift
//
// ----------------------------

import Security
import Foundation

open class KeychainSwift {
  
  var lastQueryParameters: [String: Any]? // Used by the unit tests
  open var lastResultCode: OSStatus = noErr
  var keyPrefix = "" // Can be useful in test.
  open var accessGroup: String?
  public init() { }
  
  public init(keyPrefix: String) {
    self.keyPrefix = keyPrefix
  }
  
  open func set(_ value: String, forKey key: String, withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
    
    if let value = value.data(using: String.Encoding.utf8) {
      return set(value, forKey: key, withAccess: access)
    }
    
    return false
  }

  open func set(_ value: Data, forKey key: String, withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
    
    _ = delete(key) // Delete any existing key before saving it

    let accessible = access?.value ?? KeychainSwiftAccessOptions.defaultOption.value
      
    let prefixedKey = keyWithPrefix(key)
      
    var query = [
      KeychainSwiftConstants.klass: kSecClassGenericPassword,
      KeychainSwiftConstants.attrAccount: prefixedKey,
      KeychainSwiftConstants.valueData: value,
      KeychainSwiftConstants.accessible: accessible
    ] as [String: Any]

    // swiftlint:disable:next force_cast
    query = addAccessGroupWhenPresent(query as! [String: NSObject])
    lastQueryParameters = query
    
    lastResultCode = SecItemAdd(query as CFDictionary, nil)
    
    return lastResultCode == noErr
  }

  open func set(_ value: Bool, forKey key: String, withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
    
    var localValue = value
    let data = Data(bytes: &localValue, count: MemoryLayout<Bool>.size)
    return set(data, forKey: key, withAccess: access)
  }

  open func get(_ key: String) -> String? {
    if let data = getData(key) {
      if let currentString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
        return currentString
      }
      
      lastResultCode = -67853 // errSecInvalidEncoding
    }

    return nil
  }
  
  open func getData(_ key: String) -> Data? {
    let prefixedKey = keyWithPrefix(key)
    
    var query: [String: NSObject] = [
      KeychainSwiftConstants.klass: kSecClassGenericPassword,
      KeychainSwiftConstants.attrAccount: prefixedKey as NSObject,
      KeychainSwiftConstants.returnData: kCFBooleanTrue,
      KeychainSwiftConstants.matchLimit: kSecMatchLimitOne ]
    
    query = addAccessGroupWhenPresent(query)
    lastQueryParameters = query
    
    var result: AnyObject?
    
    lastResultCode = withUnsafeMutablePointer(to: &result) {
      SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
    }
    
    if lastResultCode == noErr { return result as? Data }
    
    return nil
  }

  open func getBool(_ key: String) -> Bool? {
    guard let data = getData(key) else { return nil }
    var boolValue = false
    (data as NSData).getBytes(&boolValue, length: MemoryLayout<Bool>.size)
    return boolValue
  }
  
  open func delete(_ key: String) -> Bool {
    let prefixedKey = keyWithPrefix(key)

    var query: [String: NSObject] = [
      KeychainSwiftConstants.klass: kSecClassGenericPassword,
      KeychainSwiftConstants.attrAccount: prefixedKey as NSObject ]
    
    query = addAccessGroupWhenPresent(query)
    lastQueryParameters = query
    
    lastResultCode = SecItemDelete(query as CFDictionary)
    
    return lastResultCode == noErr
  }

  open func clear() -> Bool {
    var query: [String: NSObject] = [ kSecClass as String: kSecClassGenericPassword ]
    query = addAccessGroupWhenPresent(query)
    lastQueryParameters = query
    
    lastResultCode = SecItemDelete(query as CFDictionary)
    
    return lastResultCode == noErr
  }
  
  func keyWithPrefix(_ key: String) -> String {
    return "\(keyPrefix)\(key)"
  }
  
  func addAccessGroupWhenPresent(_ items: [String: NSObject]) -> [String: NSObject] {
    guard let accessGroup = accessGroup else { return items }
    
    var result: [String: NSObject] = items
    result[KeychainSwiftConstants.accessGroup] = accessGroup as NSObject?
    return result
  }
}

// ----------------------------
//
// KeychainSwiftAccessOptions.swift
//
// ----------------------------

public enum KeychainSwiftAccessOptions {

  case accessibleWhenUnlocked
  case accessibleWhenUnlockedThisDeviceOnly
  case accessibleAfterFirstUnlock
  case accessibleAfterFirstUnlockThisDeviceOnly
  case accessibleAlways
  @available(iOS 8, *)
  case accessibleWhenPasscodeSetThisDeviceOnly
  case accessibleAlwaysThisDeviceOnly
  
  static var defaultOption: KeychainSwiftAccessOptions {
    return .accessibleWhenUnlocked
  }
  
  var value: String {
    switch self {
    case .accessibleWhenUnlocked:
      return toString(kSecAttrAccessibleWhenUnlocked)
      
    case .accessibleWhenUnlockedThisDeviceOnly:
      return toString(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
      
    case .accessibleAfterFirstUnlock:
      return toString(kSecAttrAccessibleAfterFirstUnlock)
      
    case .accessibleAfterFirstUnlockThisDeviceOnly:
      return toString(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
      
    case .accessibleAlways:
      return toString(kSecAttrAccessibleAlways)
      
    case .accessibleWhenPasscodeSetThisDeviceOnly:
        return toString(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
      
    case .accessibleAlwaysThisDeviceOnly:
      return toString(kSecAttrAccessibleAlwaysThisDeviceOnly)
    }
  }
  
  func toString(_ value: CFString) -> String {
    return KeychainSwiftConstants.toString(value)
  }
}

// ----------------------------
//
// TegKeychainConstants.swift
//
// ----------------------------

public struct KeychainSwiftConstants {
  public static var accessGroup: String { return toString(kSecAttrAccessGroup) }
  public static var accessible: String { return toString(kSecAttrAccessible) }
  public static var attrAccount: String { return toString(kSecAttrAccount) }
  public static var klass: String { return toString(kSecClass) }
  public static var matchLimit: String { return toString(kSecMatchLimit) }
  public static var returnData: String { return toString(kSecReturnData) }
  public static var valueData: String { return toString(kSecValueData) }
  
  static func toString(_ value: CFString) -> String {
    return value as String
  }
}
