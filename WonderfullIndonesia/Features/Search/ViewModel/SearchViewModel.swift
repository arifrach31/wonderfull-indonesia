//
//  SearchViewModel.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 29/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
  
  private let disposeBag = DisposeBag()
  
  var interactor = FavoriteInteractor()
  var searchDestination: BehaviorRelay<[Place]?>
  var searchText: BehaviorRelay<String?>
  var countSearchDestination: Int {
    return searchDestination.value?.count ?? 0
  }
  
  init() {
    searchDestination = BehaviorRelay(value: nil)
    searchText = BehaviorRelay(value: "")
  }
  
  func isEmptyResult(_ countResult: Int) -> Bool {
    if countResult < 1 {
      return true
    }
    return false
  }
  
}
