//
//  FavoriteViewModel.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 29/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import Foundation

class FavoriteViewModel {
  
  var interactor = FavoriteInteractor()
  var countFavoritDestination: Int {
    guard let destination = interactor.currentDestination() else { return 0 }
    return destination.places?.filter({ $0.isFavorit }).count ?? 0
  }
  
  func isEmptyResult(_ countResult: Int) -> Bool {
    if (countResult < 1) {
      return true
    }
    return false
  }
  
}
