//
//  About.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 24/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import ObjectMapper

// MARK: - About
struct About: Mappable {
  var error: Bool?
  var message: String?
  var data: Me?

  init?(map: Map) {
    mapping(map: map)
  }

  mutating func mapping(map: Map) {
    error <- map["error"]
    message <- map["message"]
    data <- map["data"]
  }
}

// MARK: - Me
struct Me: Mappable {
  var id: Int?
  var name, job, company,
      instagram, image: String?

  init?(map: Map) {
    mapping(map: map)
  }

  mutating func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    job <- map["job"]
    company <- map["company"]
    instagram <- map["instagram"]
    image <- map["image"]
  }
}
