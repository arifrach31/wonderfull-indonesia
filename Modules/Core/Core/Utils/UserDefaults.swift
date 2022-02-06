//
//  UserDefaults.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import Foundation

extension UserDefaults {
  public static func get(_ key: String) -> String? {
    let val = UserDefaults.standard.value(forKey: key)
    if let v = val as? String {
      return Encryption.decrypt(param: v)
    }
    
    return nil
  }
  
  public static func delete(_ key: String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
  }
  
  public static func set(_ val: String, forKey key: String) {
    let v = Encryption.encrypt(param: val)
    UserDefaults.standard.set(v, forKey: key)
    UserDefaults.standard.synchronize()
  }
}

protocol ObjectSavable {
  func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
  func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

public enum ObjectSavableError: String, LocalizedError {
  case unableToEncode = "Unable to encode object into data"
  case noValue = "No data object found for the given key"
  case unableToDecode = "Unable to decode object into given type"

  public var errorDescription: String? {
    rawValue
  }
}

extension UserDefaults: ObjectSavable {
  public func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(object)
      set(data, forKey: forKey)
    } catch {
      throw ObjectSavableError.unableToEncode
    }
  }

  public func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
    guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
    let decoder = JSONDecoder()
    do {
      let object = try decoder.decode(type, from: data)
      return object
    } catch {
      throw ObjectSavableError.unableToDecode
    }
  }
}
