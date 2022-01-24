//
//  Destination.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 09/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import ObjectMapper

public protocol PlacePair {
  var isFavorit: Bool { get set }
  var like: Int { get set }
}

// MARK: - Destination
struct Destination: Mappable {
  var error: Bool?
  var message: String?
  var count: Int?
  var places: [Place]?

  init?(map: Map) {
    mapping(map: map)
  }

  mutating func mapping(map: Map) {
    error <- map["error"]
    message <- map["message"]
    count <- map["count"]
    places <- map["places"]
  }

  public func save() {
    if let jsonString = self.toJSONString() {
      Persistent.shared.set(key: .destination, value: jsonString)
      Notifications.favoritNotifications.post()
    }
  }

  public static func clear() {
    Persistent.shared.delete(key: .destination)
  }

  public static var current: Destination? {
    guard let destinationString = Persistent.shared.get(key: .destination),
      let destination = Destination(JSONString: destinationString) else {
      return nil
    }

    return destination
  }
}

// MARK: - Place
struct Place: Mappable, PlacePair {
  var id: Int?
  var name, description, address,
      image, weather, price: String?
  var isFavorit: Bool = false
  var like: Int = 0

  init?(map: Map) {
    mapping(map: map)
  }

  mutating func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    description <- map["description"]
    address <- map["address"]
    like <- map["like"]
    image <- map["image"]
    isFavorit <- map["isFavorit"]
    weather <- map["weatherTemperature"]
    price <- map["price"]
  }
}
