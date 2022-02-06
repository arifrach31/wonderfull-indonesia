//
//  FavoriteInteractor.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 29/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import Foundation

protocol FavoriteInteractorProtocol: AnyObject {
  func currentDestination() -> Destination?
  func save(destination: Destination)
  func handleDestinationFav(id: Int, destination: Destination) -> Bool
}

class FavoriteInteractor: FavoriteInteractorProtocol {
  
  func currentDestination() -> Destination? {
    guard let destinationString = Persistent.shared.get(key: .destination),
      let destination = Destination(JSONString: destinationString) else {
      return nil
    }

    return destination
  }
  
  func save(destination: Destination) {
    if let jsonString = destination.toJSONString() {
      Persistent.shared.set(key: .destination, value: jsonString)
      Notifications.favoritNotifications.post()
    }
  }
  
  func handleDestinationFav(id: Int, destination: Destination) -> Bool {
    var isFavorit: Bool = false
    var destination = destination
    for i in 0..<(destination.count ?? 0) {
      // swiftlint:disable for_where
      if destination.places?[i].id == id {
        isFavorit = destination.places?[i].isFavorit ?? false ? true : false
        destination.places?[i].isFavorit = !isFavorit
      }
    }
    save(destination: destination)
    
    return isFavorit
  }
  
}
