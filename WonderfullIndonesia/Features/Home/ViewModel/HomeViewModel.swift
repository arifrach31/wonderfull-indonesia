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
  
  private let disposeBag = DisposeBag()
  
  var interactor = FavoriteInteractor()
  var isLoading: BehaviorRelay<Bool>
  var destination: BehaviorRelay<Destination?>
  var error: BehaviorRelay<ApiError?>
  
  init() {
    isLoading = BehaviorRelay(value: false)
    destination = BehaviorRelay(value: nil)
    error = BehaviorRelay(value: nil)
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
}
