//
//  HomeViewModel.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 09/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
  var isLoading: BehaviorRelay<Bool>
  var destination: BehaviorRelay<Destination?>
  var error: BehaviorRelay<ApiError?>
  var searchDestination: BehaviorRelay<[Place]?>
  var searchText: BehaviorRelay<String?>
  
  var countSearchDestination: Int {
    return searchDestination.value?.count ?? 0
  }
  var countFavoritDestination: Int {
    return Destination.current?.places?.filter({ $0.isFavorit }).count ?? 0
  }

  private let disposeBag = DisposeBag()

  init() {
    isLoading = BehaviorRelay(value: false)
    destination = BehaviorRelay(value: nil)
    error = BehaviorRelay(value: nil)
    searchDestination = BehaviorRelay(value: nil)
    searchText = BehaviorRelay(value: "")
  }

  func requestDestination() {
    isLoading.accept(true)

    GeneralInteractor.api(BaseApi.destination, responseType: Destination.self).subscribe(onNext: {[weak self] (response) in
      self?.destination.accept(response)
    }, onError: { [weak self] (er) in
      self?.error.accept(er as? ApiError)
      self?.isLoading.accept(false)
    }, onCompleted: { [weak self] in
      self?.isLoading.accept(false)
    }).disposed(by: disposeBag)
  }

  func handleDestinationFav(_ id: Int) -> Bool {
    var isFavorit: Bool = false
    guard var data = Destination.current else { return false }
    for i in 0..<(data.count ?? 0) {
      if data.places?[i].id == id {
        isFavorit = data.places?[i].isFavorit ?? false ? true : false
        data.places?[i].isFavorit = !isFavorit
      }
    }
    data.save()
    return isFavorit
  }

  func isEmptyResult(_ countResult: Int) -> Bool {
    if (countResult < 1) {
      return true
    }
    return false
  }
}
